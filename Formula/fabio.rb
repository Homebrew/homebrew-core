class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.5.14.tar.gz"
  sha256 "4d0be0922a371383912a0fcf2bcd325a91aad9fc9579dcda6dbc075c7dbbbc19"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "197702e971927d8224bee4a7db06d7e600bd2860bbc055f1df19e20ad2e63358" => :catalina
    sha256 "d272c77961183cb8361d588c041161de1ecdd729e5857f19e3d4822ddaaf657c" => :mojave
    sha256 "627bbe4f66761102c57375c327d4352a20825b744e9a653b42c308f3d08e4d45" => :high_sierra
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

    consul_default_port = 8500
    fabio_default_port = 9999
    localhost_ip = "127.0.0.1".freeze

    def port_open?(ip_address, port, seconds = 1)
      Timeout.timeout(seconds) do
        TCPSocket.new(ip_address, port).close
      end
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
      false
    end

    if port_open?(localhost_ip, fabio_default_port)
      puts "Fabio already running or Consul not available or starting fabio failed."
      false
    else
      if port_open?(localhost_ip, consul_default_port)
        puts "Consul already running"
      else
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
          puts "consul started"
        end
        sleep 30
      end
      fork do
        exec "#{bin}/fabio &>fabio-start.out&"
        puts "fabio started"
      end
      sleep 10
      assert_equal true, port_open?(localhost_ip, fabio_default_port)
      system "killall", "fabio" # fabio forks off from the fork...
      system "consul", "leave"
    end
  end
end
