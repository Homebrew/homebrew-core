class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.5.3/nagios-4.5.3.tar.gz"
  sha256 "5ad0f9eadcd504d4da41d81c01d1be22e9dc183e851fc74c9083de8359f9a5f4"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_sonoma:   "d269ea8bf5d0d9783250101155522722a0bdce16b30ec310533269964de7fd8e"
    sha256 arm64_ventura:  "c225d459e4ee1021a04afb235f3dcc62092c9c896809d8c626d91327c5aadbdd"
    sha256 arm64_monterey: "1459795551863ad66b1f2c2a91f7a6b0ad29b3588178ceb3c9ad9ea8a74fd0ed"
    sha256 sonoma:         "6cd0b29b520cbc4a3990f3e4dd1b9cede0ef9c780b618a00bc47e4f84f9c975a"
    sha256 ventura:        "b04dc13e9027626aa94d63d73a9bc6e8e4dac2ee40a4aa040410fa990b4d85af"
    sha256 monterey:       "9a75f87c9332ed7378abb8ab1b6a48dbd6fb38ec987190a45a774879ec91d6f4"
    sha256 x86_64_linux:   "184338ac0cea525eaf728c035d6b4a3aeff2b86a5c24ce9435a7b51dd8b41ab4"
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
