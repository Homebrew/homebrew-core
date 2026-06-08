class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nagioscore/releases/download/nagios-4.5.13/nagios-4.5.13.tar.gz"
  sha256 "43d533d2bb58a81221741ab2f0c27b478fc0a80fb98f83b748ecc56327c68718"
  license "GPL-2.0-only"
  head "https://github.com/NagiosEnterprises/nagioscore.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "c0d07c87b4f62d659234ec635d4e0d79ee72ad6672fdaf4039b07091d3a7dcc5"
    sha256 arm64_sequoia: "f4d256346a7c47542eb266c8ec37b435437fd75fbb6c671e56c20bee0eaf4158"
    sha256 arm64_sonoma:  "decae65011b78d9c79b7e2cd6d493d98a3b3ef911a765f8577e5f2c8384c1b9d"
    sha256 sonoma:        "b7bc3bfbcd8be5e1fec6189fa818562b3fefa2dc312becef93148443a1f9ac25"
    sha256 arm64_linux:   "10e48717e0f9b2e6bf108afe61d9164784d090de56527d4dcf693766bdc039ee"
    sha256 x86_64_linux:  "4744176b2007837b89090e670c571d5780ad19afd0fb2f58cafcc1dd1fa58b5c"
  end

  depends_on xcode: :build
  depends_on "gd"
  depends_on "libpng"
  depends_on "openssl@4"

  uses_from_macos "unzip"

  on_macos do
    depends_on "jpeg-turbo"
  end

  def nagios_sbin
    prefix/"cgi-bin"
  end

  def nagios_etc
    etc/"nagios"
  end

  def nagios_var
    var/"lib/nagios"
  end

  def htdocs
    pkgshare/"htdocs"
  end

  def user
    Utils.safe_popen_read("id", "-un").chomp
  end

  def group
    Utils.safe_popen_read("id", "-gn").chomp
  end

  def install
    args = [
      "--sbindir=#{nagios_sbin}",
      "--sysconfdir=#{nagios_etc}",
      "--localstatedir=#{nagios_var}",
      "--datadir=#{htdocs}",
      "--libexecdir=#{HOMEBREW_PREFIX}/sbin", # Plugin dir
      "--with-cgiurl=/nagios/cgi-bin",
      "--with-htmurl=/nagios",
      "--with-nagios-user=#{user}",
      "--with-nagios-group='#{group}'",
      "--with-command-user=#{user}",
      "--with-httpd-conf=#{share}",
      "--with-ssl=#{Formula["openssl@4"].opt_prefix}",
      "--disable-libtool",
    ]
    args << "--with-command-group=_www" if OS.mac?

    system "./configure", *std_configure_args, *args
    system "make", "all"
    system "make", "install"

    # Install config
    system "make", "install-config"
    system "make", "install-webconf"
  end

  def post_install
    (var/"lib/nagios/rw").mkpath

    config = etc/"nagios/nagios.cfg"
    return unless config.exist?
    return if config.read.include?("nagios_user=#{ENV["USER"]}")

    inreplace config, /^nagios_user=.*/, "nagios_user=#{ENV["USER"]}"
  end

  service do
    run [opt_bin/"nagios", etc/"nagios/nagios.cfg"]
    keep_alive true
    require_root true
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nagios --version")
  end
end
