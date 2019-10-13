class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.5.12.tar.gz"
  sha256 "0da898594baff6e2ecb2709a974b4a9787bba6d8bf79016e180413e9761c8fec"
  head "https://github.com/fabiolb/fabio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b1e06ba1ad9f1d68370103e9f2aff5ae44ca54c05a5a91e8ebdcd3c6be5607b7" => :catalina
    sha256 "d5fe932d0ce8a776dd7b45b50b3da9560304b4d8e4a74c6beb01bf9583c341ad" => :mojave
    sha256 "691e164925ba1a77cfc178be569aa09c4b2ac5cb2f57fdf617670f09dbe5a7dc" => :high_sierra
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
