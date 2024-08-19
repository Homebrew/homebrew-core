class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.5.4/nagios-4.5.4.tar.gz"
  sha256 "eca13c692d1371cd07328ac3431613f7b09886adff9c37833a37377a5e35f2bf"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "f5aadb891a53d8aa972359204f9b7e83f9feddc2266403dd9770885b3ec5356a"
    sha256 arm64_ventura:  "17c60c63fb02b91be1cec41d4ba29f118a2fa1f3687b253df3e9958e2ee5f8e0"
    sha256 arm64_monterey: "3b5c2217cceba93a30d66e735299e4280ab6828033ba3454f1c4a4eef5de1459"
    sha256 sonoma:         "7849b4f82188d7adda5f9f58dc46c39e30ffd0a80de3810b694365280ea41669"
    sha256 ventura:        "baada975f4031c8424d272269da767844e29a24cb8bf806b16133663f1a74a31"
    sha256 monterey:       "756bc78414b221d533a76b4652fcc4a07698c05659f6050cd11a9be7a3844483"
    sha256 x86_64_linux:   "8f373a4e799a7d3d5ae4bf14292e7662f039098d2ddc7838aa84e01ca8a05731"
  end

  depends_on "gd"
  depends_on "libpng"
  depends_on "openssl@3"

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
