class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.5.10.tar.gz"
  sha256 "6d11f5115d41bba0462a1d289b6a09db9cacb8728d0d2cef6a096ce8416475b8"
  head "https://github.com/fabiolb/fabio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e9e27a699f09e25dcd5c1dc403eda6c8e533f8fe96b328277898ecfa31b5c4e1" => :mojave
    sha256 "3c954b8625010295436faf57ceca390fa7a8947f838fe0c7ed5ddb5e04a4122b" => :high_sierra
    sha256 "97157de3fe8eca2a6162f08364ad0ae692093d3fc78c6e1551d415416089bda0" => :sierra
  end

  depends_on "go" => :build
  depends_on "consul"

  def install
    mkdir_p buildpath/"src/github.com/fabiolb"
    ln_s buildpath, buildpath/"src/github.com/fabiolb/fabio"

    ENV["GOPATH"] = buildpath.to_s
    ENV["GO111MODULE"] = "off"

    system "go", "install", "github.com/fabiolb/fabio"
    bin.install "#{buildpath}/bin/fabio"
  end

  test do
    require "socket"
    require "timeout"

    CONSUL_DEFAULT_PORT = 8500
    FABIO_DEFAULT_PORT = 9999
    LOCALHOST_IP = "127.0.0.1".freeze

    def port_open?(ip_address, port, seconds = 1)
      Timeout.timeout(seconds) do
        TCPSocket.new(ip_address, port).close
      end
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
      false
    end

    if !port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      if !port_open?(LOCALHOST_IP, CONSUL_DEFAULT_PORT)
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
          puts "consul started"
        end
        sleep 30
      else
        puts "Consul already running"
      end
      fork do
        exec "#{bin}/fabio &>fabio-start.out&"
        puts "fabio started"
      end
      sleep 10
      assert_equal true, port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      system "killall", "fabio" # fabio forks off from the fork...
      system "consul", "leave"
    else
      puts "Fabio already running or Consul not available or starting fabio failed."
      false
    end
  end
end
