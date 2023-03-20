class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.10/nagios-4.4.10.tar.gz"
  sha256 "8118dcfa0ce1c69506ba582c9ff0190d5b348bae0006b117eb17ada3bb5c776d"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "290d9ff2fd3a8d76d83df7ed7b445f697927c43f729e070ed1ff69194e7bc2fa"
    sha256 arm64_monterey: "d8be8e2f7e135c090861150657cacda5339cea9e0d00955f85d6ef8edc043809"
    sha256 arm64_big_sur:  "7fb5a5fc186f90ac19e74be2e2ddfcce7523b5ad45d29ee67fe4278d74135e44"
    sha256 ventura:        "5a8a68d1f4d2fa9706a8c84787b9bf35c70f95db6ccd801e99ea05e6d22f8c68"
    sha256 monterey:       "56780c151f1903a218681678e81ace045067dd6eb27613d8beeb96fdbbca22cc"
    sha256 big_sur:        "c6dbbe42f9fb6c0d86afd0902037a95ba8bde35d133a31f7ba903762a11f5956"
    sha256 x86_64_linux:   "921787f28ff72c7e6e4e050e523b081f4a5e5b9f53a1266ea4daeff12075136f"
  end

  depends_on "gd"
  depends_on "libpng"
  depends_on "nagios-plugins"
  depends_on "openssl@3"

  uses_from_macos "unzip"

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
      "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
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
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nagios --version")
  end
end
