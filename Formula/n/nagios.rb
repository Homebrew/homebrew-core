class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.14/nagios-4.4.14.tar.gz"
  sha256 "507caac1ae89974ffa8ea5b310aa048ba9ab00cd9711693ef36eb17eeea9f84f"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "3e11c8d47ab27bfe9ae845d6a390dda158b2f3fc3f579fcabdb79a7cdbba4451"
    sha256 arm64_monterey: "f71f5b21f4f04d8506eb3b16fcf3e6ab8953cef5c08588e4490a44cd5db1afa0"
    sha256 arm64_big_sur:  "2fadc0c51d7b242433b17f35afd047da6816512bd8862307ad8c71cd15cef64c"
    sha256 ventura:        "508f7b24fd3b5112ce3f3e4efd5f370a4d50052baa98b972dcb98db369b00df5"
    sha256 monterey:       "9fb3c90a139643ea2d17cd914476dbe8631d45f52a2b07b6952d9c96c376fecc"
    sha256 big_sur:        "5b818ef03ef91ac3851c0d110018e1d2e767b4360ddb0bee3b5862aff7f88a7a"
    sha256 x86_64_linux:   "d53805470dfaf177423fd5279ce71b8cbaef2eec739c676fde0790d48f1f7254"
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
