class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.8/nagios-4.4.8.tar.gz"
  sha256 "d5e1636c27d6baa7acf00e52f38e593541d743a497536cddf16d5940cb108984"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "fba01669d52128f8fad77bab933abe884b2b1e488d684649d60e17447f19b0a1"
    sha256 arm64_big_sur:  "54f9aad41a5d8a9211940e13b8e71659bc8505c45729b34deadaccb42b5252af"
    sha256 monterey:       "5ef865a3d71e38c32f508815753b4e6ce7d6e227e179d09a8c9e87c9aa9d12fd"
    sha256 big_sur:        "fe981f4a5d076729fb2e58cd61f17361bb40bcf5f8aa89ee0ec0c6c232651b6e"
    sha256 catalina:       "24e18c45dfdad103e2b8d593641d96062a9371dd5d27f4cf3719bdaad5d8795f"
    sha256 x86_64_linux:   "e7e206055508c0927bcfa591be0f4c1ca5d4ddf824bb4e32fe0bf819c51d9a69"
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
    return unless config.exist?
    return if config.read.include?("nagios_user=#{ENV["USER"]}")

    inreplace config, /^nagios_user=.*/, "nagios_user=#{ENV["USER"]}"
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
