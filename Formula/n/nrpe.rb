class Nrpe < Formula
  desc "Nagios remote plugin executor"
  homepage "https://www.nagios.org/"
  url "https://github.com/NagiosEnterprises/nrpe/releases/download/nrpe-4.1.3/nrpe-4.1.3.tar.gz"
  sha256 "5a86dfde6b9732681abcd6ea618984f69781c294b8862a45dfc18afaca99a27a"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "07fee8d6d39bfded2363a9ffb8c95ca5700948e889194f0f5f21d149bbffcf1f"
    sha256 cellar: :any,                 arm64_sequoia: "13aae650600b1f2bba6c2ae01fb48b20be2ea55382ef85b930b3800ebac3629a"
    sha256 cellar: :any,                 arm64_sonoma:  "2402923dcc08342f07df2ed6eca7be468ede9ab2446731dc1d6a5d09b445be32"
    sha256 cellar: :any,                 sonoma:        "a1eb81992236474786db808dc9dfd8b5a605c08a30505c00383a8d2770d06764"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21b4958641e1851b4cb580603b4cbe0eb4de0441bd01d67baa8f7625ce983cd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "777c9bbafb34853267f741afdd9f3e9977c82b2a6e8892e522c582fde5f24e4e"
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
