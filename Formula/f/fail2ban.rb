class Fail2ban < Formula
  desc "Scan log files and ban IPs showing malicious signs"
  homepage "https://www.fail2ban.org/"
  url "https://github.com/fail2ban/fail2ban/archive/1.0.2.tar.gz"
  sha256 "ae8b0b41f27a7be12d40488789d6c258029b23a01168e3c0d347ee80b325ac23"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0b85f9c530ea11f18748d36b4385b9350592b56f8086c74f513372bff3968878"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b85f9c530ea11f18748d36b4385b9350592b56f8086c74f513372bff3968878"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b85f9c530ea11f18748d36b4385b9350592b56f8086c74f513372bff3968878"
    sha256 cellar: :any_skip_relocation, sonoma:         "e6837df7ad022e5595329922103f21b16f062cc26cbf4f68995cd435f8935f15"
    sha256 cellar: :any_skip_relocation, ventura:        "e6837df7ad022e5595329922103f21b16f062cc26cbf4f68995cd435f8935f15"
    sha256 cellar: :any_skip_relocation, monterey:       "e6837df7ad022e5595329922103f21b16f062cc26cbf4f68995cd435f8935f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41468dd0a4be14f7ff63caec323b7fa248cf8c17f02640ebc45d592e99b3a454"
  end

  depends_on "help2man" => :build
  depends_on "python-setuptools" => :build
  depends_on "sphinx-doc" => :build
  depends_on "python@3.12"

  def install
    python3 = "python3.12"
    ENV["PYTHON"] = which(python3)

    rm "setup.cfg"
    Pathname.glob("config/paths-*.conf").reject do |pn|
      pn.fnmatch?("config/paths-common.conf") || pn.fnmatch?("config/paths-osx.conf")
    end.map(&:unlink)

    # Replace paths in config
    inreplace "config/jail.conf", "before = paths-debian.conf", "before = paths-osx.conf"

    # Replace hardcoded paths
    inreplace_etc_var("setup.py")
    inreplace_etc_var(Pathname.glob("config/{action,filter}.d/**/*").select(&:file?), audit_result: false)
    inreplace_etc_var(["config/fail2ban.conf", "config/paths-common.conf", "doc/run-rootless.txt"])
    inreplace_etc_var(Pathname.glob("fail2ban/client/*"), audit_result: false)

    inreplace "fail2ban/server/asyncserver.py", "/var/run/fail2ban/fail2ban.sock",
              var/"run/fail2ban/fail2ban.sock"

    inreplace_etc_var(Pathname.glob("fail2ban/tests/**/*").select(&:file?), audit_result: false)
    inreplace_etc_var(Pathname.glob("man/*"), audit_result: false)

    # Fix doc compilation
    inreplace "setup.py", "/usr/share/doc/fail2ban", doc
    inreplace "setup.py", "if os.path.exists('#{var}/run')", "if True"
    inreplace "setup.py", "platform_system in ('linux',", "platform_system in ('linux', 'darwin',"

    # Replace 2to3 since we don't create an unversioned symlink in libexec
    inreplace "fail2ban-2to3", " 2to3 ", " 2to3-#{Language::Python.major_minor_version python3} "

    system "./fail2ban-2to3"
    system python3, *Language::Python.setup_install_args(prefix, python3), "--without-tests"

    cd "doc" do
      system "make", "dirhtml", "SPHINXBUILD=sphinx-build"
      doc.install "build/dirhtml"
    end

    man1.install Pathname.glob("man/*.1")
    man5.install "man/jail.conf.5"
    # Install into `bash-completion@2` path as not compatible with `bash-completion`
    (share/"bash-completion/completions").install "files/bash-completion" => "fail2ban"
  end

  def inreplace_etc_var(targets, audit_result: true)
    inreplace targets do |s|
      s.gsub! %r{/etc}, etc, audit_result
      s.gsub! %r{/var}, var, audit_result
    end
  end

  def post_install
    (etc/"fail2ban").mkpath
    (var/"run/fail2ban").mkpath
  end

  def caveats
    <<~EOS
      Before using Fail2Ban for the first time you should edit the jail
      configuration and enable the jails that you want to use, for instance
      ssh-ipfw. Also, make sure that they point to the correct configuration
      path. I.e. on Mountain Lion the sshd logfile should point to
      /var/log/system.log.

        * #{etc}/fail2ban/jail.conf

      The Fail2Ban wiki has two pages with instructions for macOS Server that
      describes how to set up the Jails for the standard macOS Server
      services for the respective releases.

        10.4: https://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.4)
        10.5: https://www.fail2ban.org/wiki/index.php/HOWTO_Mac_OS_X_Server_(10.5)

      Please do not forget to update your configuration files.
      They are in #{etc}/fail2ban.
    EOS
  end

  service do
    run [opt_bin/"fail2ban-client", "-x", "start"]
    require_root true
  end

  test do
    system "#{bin}/fail2ban-client", "--test"

    (testpath/"test.log").write <<~EOS
      Jan 31 11:59:59 [sshd] error: PAM: Authentication failure for test from 127.0.0.1
    EOS
    system "#{bin}/fail2ban-regex", "test.log", "sshd"
  end
end
