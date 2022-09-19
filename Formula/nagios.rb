class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.7/nagios-4.4.7.tar.gz"
  sha256 "6429d93cc7db688bc529519a020cad648dc55b5eff7e258994f21c83fbf16c4d"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "f129414f6baa43479019c88b0efcc9000fe774ee28d6516c6ebd0f5cedec5b8c"
    sha256 arm64_big_sur:  "46b24f0161ce9b73425fd8e96704b162d60e8cc128805ed85069dbd2c397ba96"
    sha256 monterey:       "09326aea33e587a7d5f46f78b7f773ae76e5cd02071ba6a4ab309d2b76d91b4a"
    sha256 big_sur:        "5f0d5c561f17014252b5d1cfd3df48e409045618d05443eef83cde1a3cf2eade"
    sha256 catalina:       "49cb65b966dbc3988b0509596818bd22fa066e9f931a7b09579e6246eb26d23f"
    sha256 x86_64_linux:   "3ef3a37c3d7421022f1edfa6f36d447354c1008034b7ef5b71ff84a0c3a1b418"
  end

  depends_on "gd"
  depends_on "libpng"
  depends_on "nagios-plugins"
  depends_on "openssl@1.1"

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
      "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
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
    return unless File.exist?(config)
    return if File.read(config).include?(ENV["USER"])

    inreplace config, "brew", ENV["USER"]
  end

  def caveats
    <<~EOS
      First we need to create a command dir using superhuman powers:

        mkdir -p #{nagios_var}/rw
        sudo chgrp _www #{nagios_var}/rw
        sudo chmod 2775 #{nagios_var}/rw

      Then install the Nagios web frontend into Apple's built-in Apache:

        1) Turn on Personal Web Sharing.

        2) Load the cgi and php modules by patching /etc/apache2/httpd.conf:

          -#LoadModule php5_module        libexec/apache2/libphp5.so
          +LoadModule php5_module        libexec/apache2/libphp5.so

          -#LoadModule cgi_module libexec/apache2/mod_cgi.so
          +LoadModule cgi_module libexec/apache2/mod_cgi.so

        3) Symlink the sample config and create your web account:

          sudo ln -sf #{share}/nagios.conf /etc/apache2/other/
          htpasswd -cs #{nagios_etc}/htpasswd.users nagiosadmin
          sudo apachectl restart

      Log in with your web account (and don't forget to RTFM :-)

        open http://localhost/nagios

    EOS
  end

  plist_options startup: true
  service do
    run [opt_bin/"nagios", etc/"nagios/nagios.cfg"]
    keep_alive true
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nagios --version")
  end
end
