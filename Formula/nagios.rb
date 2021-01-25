class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.6/nagios-4.4.6.tar.gz"
  sha256 "ab0d5a52caf01e6f4dcd84252c4eb5df5a24f90bb7f951f03875eef54f5ab0f4"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 "0e8c1624e0265e3889c16ce76609b49752ea8e2d3a3b55f5c48cb4e891db402f" => :big_sur
    sha256 "7724f5ce89e429cd7483f7318ca1fbb0ffeb08d4045ae2a883ef9f80a76a698f" => :arm64_big_sur
    sha256 "a9c2c8baae137bfbfa46f67d62f7fb29a0fb4327b7a366cfe44a1502207d62fd" => :catalina
    sha256 "c074419ad5ee9d3446410e7ff05b8454c840771f5cae1246a9de20e33775d4f0" => :mojave
    sha256 "162b5d50061d7a2ef4bfa8a9899d7fad3558ccfea80e105c43a66061d1780cd9" => :high_sierra
  end

  depends_on "gd"
  depends_on "libpng"
  depends_on "nagios-plugins"

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
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
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
                          "--with-command-group=_www",
                          "--with-httpd-conf=#{share}",
                          "--disable-libtool"
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

  plist_options startup: true, manual: "nagios #{HOMEBREW_PREFIX}/etc/nagios/nagios.cfg"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/nagios</string>
          <string>#{nagios_etc}/nagios.cfg</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nagios --version")
  end
end
