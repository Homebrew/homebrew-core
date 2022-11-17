class Nagios < Formula
  desc "Network monitoring and management system"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nagios-4.x/nagios-4.4.9/nagios-4.4.9.tar.gz"
  sha256 "0e793f3f3654f10961db34950a0c129240cc80222119175552d7e322a9ba4334"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(%r{url=.*?/nagios[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "0637ec5ac33730cfe9e01e8796ff24bf4ba69aa8487bde4c457999e9958ce61d"
    sha256 arm64_monterey: "689b180a922aa24bce6cd47e85bd7e09f415217b94b93619b90078677e131088"
    sha256 arm64_big_sur:  "b285d96affcdae36672b789bb3e6fb5d6e8155d34cd500542e4e4196e4452973"
    sha256 monterey:       "8c0d9035ed0a74b33d2d33f1448e3b0393afce8d1d80b2a91188367ff2e8ea0c"
    sha256 big_sur:        "a6a423daa32f7a08789b904d83bec0673d2574ee8c891b422974e131fc69f6ea"
    sha256 catalina:       "cc3e0037b069eee5e7819d32861872dad58869cae36939fe546b6624e321fb0c"
    sha256 x86_64_linux:   "ed8a37f74ff55e3e0cf1d5d454b5966d51d07408181588aa6f774b58710e4bc6"
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
