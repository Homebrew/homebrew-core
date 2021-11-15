class Fail2ban < Formula
  desc "Scan log files and ban IPs showing malicious signs"
  homepage "https://www.fail2ban.org/"
  url "https://github.com/fail2ban/fail2ban/archive/0.11.2.tar.gz"
  sha256 "383108e5f8644cefb288537950923b7520f642e7e114efb843f6e7ea9268b1e0"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bbb8f762200e892130d7f5fe082f75057f8d5fe8950c85686182872ae1cd0d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bbb8f762200e892130d7f5fe082f75057f8d5fe8950c85686182872ae1cd0d0"
    sha256 cellar: :any_skip_relocation, monterey:       "9db5992983e4db132111565b5eee72e6f7fd5f00eb63b00f5386e7b370ae0a21"
    sha256 cellar: :any_skip_relocation, big_sur:        "9db5992983e4db132111565b5eee72e6f7fd5f00eb63b00f5386e7b370ae0a21"
    sha256 cellar: :any_skip_relocation, catalina:       "9db5992983e4db132111565b5eee72e6f7fd5f00eb63b00f5386e7b370ae0a21"
    sha256 cellar: :any_skip_relocation, mojave:         "9db5992983e4db132111565b5eee72e6f7fd5f00eb63b00f5386e7b370ae0a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e842d2c8d7fe34eefe7e889fe31b597dbf398c2345efaec38af1cfabd268d0ec"
  end

  depends_on "help2man" => :build
  depends_on "sphinx-doc" => :build
  depends_on "python@3.10"

  # fixes https://github.com/fail2ban/fail2ban/issues/3098 remove in the next release
  patch do
    url "https://github.com/fail2ban/fail2ban/commit/5ac303df8a171f748330d4c645ccbf1c2c7f3497.patch?full_index=1"
    sha256 "4f22a39ae708b0c0fb59d29054e86b7c3f478a79925508833fd21f000b86aadb"
  end

  # fixes https://github.com/fail2ban/fail2ban/issues/2931 remove in the next release
  patch do
    url "https://github.com/fail2ban/fail2ban/commit/2b6bb2c1bed8f7009631e8f8c306fa3160324a49.patch?full_index=1"
    sha256 "ff0aa188dbcfedaff6f882dba00963f4faf3fa774da9cfeb7f96030050e9d8e3"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages("python3")
    ENV["PYTHON"] = which("python3")

    rm "setup.cfg"
    Dir["config/paths-*.conf"].each do |r|
      next if /paths-common\.conf|paths-osx\.conf/.match?(File.basename(r))

      rm r
    end

    # Replace paths in config
    inreplace "config/jail.conf", "before = paths-debian.conf", "before = paths-osx.conf"

    # Replace hardcoded paths
    inreplace "setup.py" do |s|
      s.gsub! %r{/etc}, etc
      s.gsub! %r{/var}, var
    end

    inreplace Dir["config/{action,filter}.d/**/*"].select { |ff| File.file?(ff) }.each do |s|
      s.gsub! %r{/etc}, etc, false
      s.gsub! %r{/var}, var, false
    end

    inreplace ["config/fail2ban.conf", "config/paths-common.conf", "doc/run-rootless.txt"].each do |s|
      s.gsub! %r{/etc}, etc
      s.gsub! %r{/var}, var
    end

    inreplace Dir["fail2ban/client/*"].each do |s|
      s.gsub! %r{/etc}, etc, false
      s.gsub! %r{/var}, var, false
    end

    inreplace "fail2ban/server/asyncserver.py", "/var/run/fail2ban/fail2ban.sock",
              var/"run/fail2ban/fail2ban.sock"

    inreplace Dir["fail2ban/tests/**/*"].select { |ff| File.file?(ff) }.each do |s|
      s.gsub! %r{/etc}, etc, false
      s.gsub! %r{/var}, var, false
    end

    inreplace Dir["man/*"].each do |s|
      s.gsub! %r{/etc}, etc, false
      s.gsub! %r{/var}, var, false
    end

    # Fix doc compilation
    inreplace "setup.py", "/usr/share/doc/fail2ban", (share/"doc")
    inreplace "setup.py", "if os.path.exists('#{var}/run')", "if True"
    inreplace "setup.py", "platform_system in ('linux',", "platform_system in ('linux', 'darwin',"

    system "./fail2ban-2to3"
    system "python3", "setup.py", "install", "--prefix=#{libexec}"

    cd "doc" do
      system "make", "dirhtml", "SPHINXBUILD=sphinx-build"
      (share/"doc").install "build/dirhtml"
    end

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
    man1.install Dir["man/*.1"]
    man5.install "man/jail.conf.5"
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

  plist_options startup: true

  service do
    run [opt_bin/"fail2ban-client", "-x", "start"]
  end

  test do
    system "#{bin}/fail2ban-client", "--test"
  end
end
