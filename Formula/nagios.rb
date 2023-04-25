class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.11/nagios-4.4.11.tar.gz"
  sha256 "f867a46fb580138c7a681e9ec53d17c4bd70321f3bfe6abaf9a9fbf7d5ca3b55"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "336be534ee2d44637a0f229f23bbfda7fa0dcd2ab3de8b58135d6f51021d6a96"
    sha256 arm64_monterey: "ec8088e4e2389cfa8cd5320faf57c3eaf70636d1c8100698656347464de8eca0"
    sha256 arm64_big_sur:  "da3cf95f5ac6cb9db28d3257f34f77d9c7e37e319e4588222376a4266285408f"
    sha256 ventura:        "da5eedea77a9a9134fab1e297700850224b5728ddd60086e4aa1a1c3620f0a5f"
    sha256 monterey:       "c604ca03d480b0120d01adbcdff2089b765df5ec5dd80c0810c8cdeb2d20cc39"
    sha256 big_sur:        "3b300c2fc99c33d797e92fe83aa0f2394c5822ad8f8576dad5c16544622a0263"
    sha256 x86_64_linux:   "e9e941b6f9e2ecb68873ec70dd41eb25d5107523c04def2db9c155bb9ce8c251"
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
