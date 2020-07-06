class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.5.13.tar.gz"
  sha256 "66af6e8dbd0e7cbd171a868fa42a611d445701fadd9782bb077cf9101ac08cdf"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9ed48161ee4b2c5bcf0ce9ce520c2506bec689b2d21735d1eb4f3a3cb470fb57" => :catalina
    sha256 "3fe400520ea3af9c28baef9b376f14d8a96c88d6c79bc057f0949e15ea9c0efe" => :mojave
    sha256 "41ae1110be9335004d77846ab554cb5ecf45f6c48f83942b95bd752c243dcc14" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "consul"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"fabio"
    prefix.install_metafiles
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
