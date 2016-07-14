class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router."
  homepage "https://github.com/eBay/fabio"
  url "https://github.com/eBay/fabio/archive/v1.1.6.tar.gz"
  sha256 "ae80fb63426cc26a432cd2e310f5c5dbb69a807eeef33b51fb9decb7771b0041"
  head "https://github.com/eBay/fabio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b37db8e75901d9f37f811a3ab11a544e0bbfbecd10b7fbb2e2216e9a8b0e55b0" => :el_capitan
    sha256 "b204f908a91b0e4bff6ad0c2c0c58945b74290de91cc46dc758d66e61cf4d727" => :yosemite
    sha256 "ecedf1c8be9864b72a9a5a63d34a600daa8040d64872895f0e0457bcfff4d622" => :mavericks
  end

  devel do
    url "https://github.com/eBay/fabio/archive/v1.2rc4.tar.gz"
    sha256 "93696b6a4caf63c190426e0ce9699f4f868dd643dcf1c07eca80a49bfbd5a085"
    version "1.2rc4"
  end

  depends_on "go" => :build
  depends_on "consul" => :recommended

  def install
    mkdir_p buildpath/"src/github.com/eBay"
    ln_s buildpath, buildpath/"src/github.com/eBay/fabio"

    ENV["GOPATH"] = buildpath.to_s

    system "go", "install", "github.com/eBay/fabio"
    bin.install "#{buildpath}/bin/fabio"
  end

  test do
    require "socket"
    require "timeout"

    CONSUL_DEFAULT_PORT=8500
    FABIO_DEFAULT_PORT=9999
    LOCALHOST_IP="127.0.0.1".freeze

    def port_open?(ip, port, seconds = 1)
      Timeout.timeout(seconds) do
        begin
          TCPSocket.new(ip, port).close
          true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          false
        end
      end
    rescue Timeout::Error
      false
    end

    if !port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      if !port_open?(LOCALHOST_IP, CONSUL_DEFAULT_PORT)
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
          puts "consul started"
        end
        sleep 15
      else
        puts "Consul already running"
      end
      fork do
        exec "#{bin}/fabio &>fabio-start.out&"
        puts "fabio started"
      end
      sleep 5
      assert_equal true, port_open?(LOCALHOST_IP, FABIO_DEFAULT_PORT)
      system "killall", "fabio" # fabio forks off from the fork...
      system "consul", "leave"
    else
      puts "Fabio already running or Consul not available or starting fabio failed."
      false
    end
  end
end
