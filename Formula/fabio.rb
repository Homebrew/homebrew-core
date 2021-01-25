class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.5.15.tar.gz"
  sha256 "19dcd4d8c6e4fe16e63e4208564d08ed442a0c724661ef4d91e9dbc85a9afbe1"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b1ea88c236dc4b04882f05377d5a9930e9e5e93c2092961bc68bd0d661daad5" => :big_sur
    sha256 "60852a8b3a6c9dbdeb14e05f209351cc75d014ffad037bb0c2ee83ff0f84edbb" => :catalina
    sha256 "d32c45abeb55519d51edc65c87c68e4bc7d117e8a0d8f8dfec5e667467e6174f" => :mojave
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
