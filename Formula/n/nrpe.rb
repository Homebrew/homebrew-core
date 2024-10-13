class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.1.1/nrpe-4.1.1.tar.gz"
  sha256 "0e716a7d904e0a441be52a0ef82c1138b949bad81c1da93056a81405aabcc0d7"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "847516e87f59235f0f6216150cecdeba6393f994d820e0c46998394734f9529a"
    sha256 cellar: :any, arm64_sonoma:   "ed1b4fc625aa2edf55576d46dce47f9d1e25f0b89f8e4f855079d1be44e175d0"
    sha256 cellar: :any, arm64_ventura:  "66a47ab90443c6996a4c768ab3dd07a8843cfdbc6f94458414fa1418ad41b975"
    sha256 cellar: :any, arm64_monterey: "a9d6f414b26a3608d12424c3b5434b0e2551e00d76a9e3130784cdbdc9908b59"
    sha256 cellar: :any, sonoma:         "ada3b8f8a310d1ea89c946b639b7357668478bacf15738e867f3dc2c8a15bdba"
    sha256 cellar: :any, ventura:        "576e707062926c833070c951194740183cb0c473b6e412142e979aafa6e66c8e"
    sha256 cellar: :any, monterey:       "df2c2fcc8e1e18a6c47bb5fe5436bf6a6e00786ed46a4d47244e18d01130a562"
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
      exec bin/"nrpe", "-n", "-c", "#{etc}/nrpe.cfg", "-d"
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
