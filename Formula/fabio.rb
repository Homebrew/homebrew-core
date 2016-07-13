require "socket"
require "timeout"

class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router."
  homepage "https://github.com/eBay/fabio"
  head "https://github.com/eBay/fabio.git"

  stable do
    url "https://github.com/eBay/fabio/archive/v1.1.6.tar.gz"
    sha256 "ae80fb63426cc26a432cd2e310f5c5dbb69a807eeef33b51fb9decb7771b0041"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "1d6834b71e007a7cd274f711cbe7c3482fb520768f9f8c406764643e9b681d68" => :el_capitan
    sha256 "e42cb1d57785e2577ccb235babd15b88dbeacec27b97d7f5a1b2cbc028d5e067" => :yosemite
    sha256 "583b780268d9ce079c9b34b965eb2e6745171042bfd80e992960f7bb73262c90" => :mavericks
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
