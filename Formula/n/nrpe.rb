class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.1.3/nrpe-4.1.3.tar.gz"
  sha256 "5a86dfde6b9732681abcd6ea618984f69781c294b8862a45dfc18afaca99a27a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4849e7eb841d00b2f10f7dd81c088226e6aebb683f5c29e64d72dc6bfb327f84"
    sha256 cellar: :any,                 arm64_sonoma:  "bc97d9570dfb3d1204feda1817e62fcebbf43898c3cbd00ee1592b1296654d8c"
    sha256 cellar: :any,                 arm64_ventura: "6c5566eca3996b993eb04867452d5a10b2ecb3a12e325916ff70256a7af8178e"
    sha256 cellar: :any,                 sonoma:        "e429d8acb7ba6187fc9118a86d36e891e79169353e3b736dd514604c8d2f5ff9"
    sha256 cellar: :any,                 ventura:       "05cd704766c25bd45a0b73ad8869dc747ba70565445a10ff1af9538d0b4cdf10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "961b74c9e9c9b6784f3ef4dba4e691390bc2d16d4cbe5f2d9f257caf20734209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22362e8eb73fba3a3346049a7ac718c06068c2048b9e79e371b5309197d80e8f"
  end

  depends_on "nagios-plugins"
  depends_on "openssl@3"

  def install
    user  = `id -un`.chomp
    group = `id -gn`.chomp

    if OS.linux?
      ENV["tmpfilesd"] = etc/"tmpfiles.d"
      (etc/"tmpfiles.d").mkpath
    end

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

  def port_open?(ip_address, port, seconds = 1)
    Timeout.timeout(seconds) do
      TCPSocket.new(ip_address, port).close
    end
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
    false
  end

  test do
    port = free_port
    cp etc/"nrpe.cfg", testpath
    inreplace "nrpe.cfg", /^server_port=5666$/, "server_port=#{port}"

    pid = spawn bin/"nrpe", "-n", "-c", "#{testpath}/nrpe.cfg", "-d"
    sleep 2
    sleep 10 if Hardware::CPU.intel?

    begin
      assert port_open?("localhost", port), "nrpe did not start"
      pid_nrpe = shell_output("pgrep nrpe").to_i
    ensure
      Process.kill("SIGINT", pid_nrpe) if pid_nrpe
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
