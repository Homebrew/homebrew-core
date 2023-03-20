class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.1.0/nrpe-4.1.0.tar.gz"
  sha256 "a1f14aa8aaf935b576cc55ab5d77b7cb9c920d7702aff44c9d18c4c841ef8ecc"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "1fc4928fdac6257f935fac1840c39f68a70e9634cc1bf9a6087011ea1804698c"
    sha256 cellar: :any, arm64_monterey: "c8ce52dc60241ee1e361db1085c8b341c2b72dbf946932efcada9e221add88dd"
    sha256 cellar: :any, arm64_big_sur:  "09b54c81df11d937d138916c8eaa5cd22795cd003f9ffa59f47927668af0b93d"
    sha256 cellar: :any, ventura:        "7a52a2a6506171a6ed4c859899cfde0614fdff521002d97098f3844e99d1f7b9"
    sha256 cellar: :any, monterey:       "83bca8ddf7e379b010c390cfd7a0bb42ff9b0d08ae09f9c81af4a44c769737dc"
    sha256 cellar: :any, big_sur:        "af5068970374e0d732400f3de3f6013215fbe95aea879109a399c5724df059f5"
  end

  depends_on "nagios-plugins"
  depends_on "openssl@3"

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    system "./configure", "--prefix=#{prefix}",
                          "--libexecdir=#{HOMEBREW_PREFIX}/sbin",
                          "--with-piddir=#{var}/run",
                          "--sysconfdir=#{etc}",
                          "--with-nrpe-user=#{user}",
                          "--with-nrpe-group=#{group}",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--with-ssl=#{Formula["openssl@3"].opt_prefix}",
                          # Set both or it still looks for /usr/lib
                          "--with-ssl-lib=#{Formula["openssl@3"].opt_lib}",
                          "--enable-ssl",
                          "--enable-command-args"

    inreplace "src/Makefile" do |s|
      s.gsub! "$(LIBEXECDIR)", "$(SBINDIR)"
      s.gsub! "$(DESTDIR)#{HOMEBREW_PREFIX}/sbin", "$(SBINDIR)"
    end

    system "make", "all"
    system "make", "install", "install-config"
  end

  def post_install
    (var/"run").mkpath
  end

  service do
    run [opt_bin/"nrpe", "-c", etc/"nrpe.cfg", "-d"]
  end

  test do
    pid = fork do
      exec "#{bin}/nrpe", "-n", "-c", "#{etc}/nrpe.cfg", "-d"
    end
    sleep 2

    begin
      output = shell_output("netstat -an")
      assert_match(/.*\*\.5666.*LISTEN/, output, "nrpe did not start")
      pid_nrpe = shell_output("pgrep nrpe").to_i
    ensure
      Process.kill("SIGINT", pid_nrpe)
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
