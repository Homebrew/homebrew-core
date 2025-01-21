class Fail2ban < Formula
  desc "Scan log files and ban IPs showing malicious signs"
  homepage "https://www.fail2ban.org/"
  url "https://github.com/fail2ban/fail2ban/archive/refs/tags/1.1.0.tar.gz"
  sha256 "474fcc25afdaf929c74329d1e4d24420caabeea1ef2e041a267ce19269570bae"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/fail2ban/fail2ban.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f59d34135a5df4be2af65f51437d5443262ab7aca9e4fe6f321c75522f23c9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f59d34135a5df4be2af65f51437d5443262ab7aca9e4fe6f321c75522f23c9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f59d34135a5df4be2af65f51437d5443262ab7aca9e4fe6f321c75522f23c9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "506fcbd09269cb3a6c9b3b19b4e24aaf969e86568f113fd3ed925fe87032cc6d"
    sha256 cellar: :any_skip_relocation, ventura:       "506fcbd09269cb3a6c9b3b19b4e24aaf969e86568f113fd3ed925fe87032cc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51ddc960fd617aa7e844a7fb5f9e58d4af857e9934a82d2dca93257ee6a0c9f9"
  end

  depends_on "sphinx-doc" => :build
  depends_on "python@3.13"

  # Drop distutils: https://github.com/fail2ban/fail2ban/pull/3728
  patch do
    url "https://github.com/fail2ban/fail2ban/commit/a763fbbdfd6486e372965b4009eb3fe5db346718.patch?full_index=1"
    sha256 "631ca7e59e21d4a9bbe6adf02d0b1ecc0fa33688d145eb5e736d961e0e55e4cd"
  end

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
  end

  def inreplace_etc_var(targets, audit_result: true)
    inreplace targets do |s|
      s.gsub!(%r{/etc}, etc, audit_result:)
      s.gsub!(%r{/var}, var, audit_result:)
    end
  end

  def post_install
    (etc/"fail2ban").mkpath
    (var/"run/fail2ban").mkpath
  end

  def caveats
    <<~EOS
      You must enable any jails by editing:
        #{etc}/fail2ban/jail.conf

      Other configuration files are in #{etc}/fail2ban. See more instructions at
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
