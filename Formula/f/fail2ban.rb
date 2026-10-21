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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c341041f3941e1b5d1e9ab68f5b18e4707f88e91e9e8da2e404075dbb3b5f2c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c341041f3941e1b5d1e9ab68f5b18e4707f88e91e9e8da2e404075dbb3b5f2c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c341041f3941e1b5d1e9ab68f5b18e4707f88e91e9e8da2e404075dbb3b5f2c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "044e488e28be6c12bd14a17d4abe37e6041b86d96dfe570a79266f0e6947fbf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "044e488e28be6c12bd14a17d4abe37e6041b86d96dfe570a79266f0e6947fbf4"
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.15"

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

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
    # Fix symlink broken by python upgrades
    ln_sf python3, bin/"fail2ban-python"
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
