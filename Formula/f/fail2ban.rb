class Fail2ban < Formula
  desc "Scan log files and ban IPs showing malicious signs"
  homepage "https://www.fail2ban.org/"
  url "https://github.com/fail2ban/fail2ban/archive/refs/tags/1.1.1.tar.gz"
  sha256 "4be0ea0488e32de260058462a44a040f0542cd26a9fb6fa6d2514f9dd8ec1609"
  license "GPL-2.0-or-later"
  head "https://github.com/fail2ban/fail2ban.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b38fcc8c71bc28a4560fac81f04904b1ea7643aeb82242a826d6a54ee063226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b38fcc8c71bc28a4560fac81f04904b1ea7643aeb82242a826d6a54ee063226"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b38fcc8c71bc28a4560fac81f04904b1ea7643aeb82242a826d6a54ee063226"
    sha256 cellar: :any_skip_relocation, sonoma:        "00b19fd0adc0bb5c54b7707bac07940bccd91142465953b94d5993828321dc0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13d6912fb1c999bf37ab43d3c326b3b2deb132a01bdd93ec7a760b76252ee9cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13d6912fb1c999bf37ab43d3c326b3b2deb132a01bdd93ec7a760b76252ee9cd"
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.14"

  def python3
    deps.map(&:to_formula)
        .find { |f| f.name.start_with?("python@") }
  end

  def install
    Pathname.glob("config/paths-*.conf").reject do |pn|
      pn.fnmatch?("config/paths-common.conf") || pn.fnmatch?("config/paths-osx.conf")
    end.map(&:unlink)

    # Replace paths in config
    inreplace "config/jail.conf", "before = paths-debian.conf", "before = paths-osx.conf"

    # 1.1.1 moved the default `banaction` into the platform paths files dropped
    # above, so restore the defaults upstream commented out to keep configs valid
    inreplace "config/jail.conf" do |s|
      s.gsub! "#banaction = iptables-multiport", "banaction = iptables-multiport"
      s.gsub! "#banaction_allports = iptables-allports", "banaction_allports = iptables-allports"
    end

    # Replace hardcoded paths
    inreplace_etc_var(Pathname.glob("config/{action,filter}.d/**/*").select(&:file?), audit_result: false)
    inreplace_etc_var(["config/fail2ban.conf", "config/paths-common.conf", "doc/run-rootless.txt"])
    inreplace_etc_var(Pathname.glob("fail2ban/**/*").select(&:file?), audit_result: false)
    inreplace_etc_var(Pathname.glob("man/*"), audit_result: false)

    # Update `data_files` from absolute to relative paths for wheel compatibility and include doc files
    inreplace "setup.py" do |s|
      s.gsub! "/etc", "./etc"
      s.gsub! "/var", "./var"
      s.gsub! "/usr/share/doc/fail2ban", "./share/doc/fail2ban"
      s.gsub! "if os.path.exists('./var/run')", "if True"
      s.gsub! "platform_system in ('linux',", "platform_system in ('linux', 'darwin',"
    end

    system python3.opt_libexec/"bin/python", "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    # Fix symlink broken by python upgrades
    ln_sf python3.opt_libexec/"bin/python", bin/"fail2ban-python"
    etc.install (prefix/"etc").children

    # Install docs
    system "make", "-C", "doc", "dirhtml", "SPHINXBUILD=sphinx-build"
    doc.install "doc/build/dirhtml"
    man1.install Pathname.glob("man/*.1")
    man5.install "man/jail.conf.5"

    # Install into `bash-completion@2` path as not compatible with `bash-completion`
    (share/"bash-completion/completions").install "files/bash-completion" => "fail2ban"

    (var/"run/fail2ban").mkpath
  end

  def inreplace_etc_var(targets, audit_result: true)
    inreplace targets do |s|
      s.gsub!(%r{/etc}, etc, audit_result:)
      s.gsub!(%r{/var}, var, audit_result:)
    end
  end

  def caveats
    <<~EOS
      You must enable any jails by editing:
        #{pkgetc}/jail.conf

      Other configuration files are in #{pkgetc}. See more instructions at
      https://github.com/fail2ban/fail2ban/wiki/Proper-fail2ban-configuration.
    EOS
  end

  service do
    run [opt_bin/"fail2ban-client", "-x", "start"]
    require_root true
  end

  test do
    system bin/"fail2ban-client", "--test"

    (testpath/"test.log").write <<~EOS
      Jan 31 11:59:59 [sshd] error: PAM: Authentication failure for test from 127.0.0.1
    EOS
    system bin/"fail2ban-regex", "test.log", "sshd"
  end
end
