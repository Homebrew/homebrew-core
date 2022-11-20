class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://downloads.sourceforge.net/project/nagios/nrpe-4.x/nrpe-4.0.3/nrpe-4.0.3.tar.gz"
  sha256 "f907ba15381adfc6eef211508abd027f8e1973116080faa4534a1191211c0340"
  license "GPL-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/nrpe[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "91ee555fcf3a779c40ce93dccc6be2cc7b02dd1a6b0e18fae7096b43eb238ec1"
    sha256 cellar: :any, arm64_monterey: "81d5307bca972fc7945af1226e9e80e3bd798a2296ef7da9fa16240c27064b28"
    sha256 cellar: :any, arm64_big_sur:  "cec620b7f488a0e443b032921653c3bbf8e43438e8ca8b02b23cf6ea9284da5c"
    sha256 cellar: :any, ventura:        "1213aefe88e396f74bc72002d81daaf592c3da0e76baaab5043a80827ab6e1d7"
    sha256 cellar: :any, monterey:       "9e8adb2e3df46f2a950a95d285d70e8142d9ce3a00eb7171fb34b27daf8624d6"
    sha256 cellar: :any, big_sur:        "0d5e76f99e6ea435cda18d6476158ced7debd4a4633176bcf1f3d6e721cd9724"
    sha256 cellar: :any, catalina:       "d142c84ff35a78b7a2705ac915552c617420ff747eb47fd8d3ba27347ec384bc"
    sha256 cellar: :any, mojave:         "ea0e988a1aef0f1905f0fe807d687096f10389c6b09f415015f713e529af4740"
  end

  depends_on "nagios-plugins"
  depends_on "openssl@1.1"

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
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          # Set both or it still looks for /usr/lib
                          "--with-ssl-lib=#{Formula["openssl@1.1"].opt_lib}",
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
