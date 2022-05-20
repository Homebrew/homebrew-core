class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.7/nagios-4.4.7.tar.gz"
  sha256 "6429d93cc7db688bc529519a020cad648dc55b5eff7e258994f21c83fbf16c4d"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "0cf6b15c9ae411bb833a5e3a02f00cf79dfe848f96f263a76b13ff6aa95b8c08"
    sha256 arm64_big_sur:  "27ef33f3fdeb9434d286ab412dde3a6b5b8c25cefba533320681f1daf136a7dc"
    sha256 monterey:       "28aee4339d0c5a399ed695f66bedef3fa16dcd3779d500ed4a9ca919b8f19297"
    sha256 big_sur:        "c6e08e7b0dccc9b77167145ec7dba514bb907eaadd7d2c7b4e15a73818d29649"
    sha256 catalina:       "382d4b6be1a3a45eac3f573cb2c6454f83ee6cf6befb4a4473ff43dbaef69551"
    sha256 x86_64_linux:   "ee38e8425334de22a988b6c8dd67baff99df1c131296b62a27333e9154714e17"
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
    args = std_configure_args + [
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

    system "./configure", *args
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
