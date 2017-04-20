class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/eBay/fabio"
  url "https://github.com/eBay/fabio/archive/v1.4.2.tar.gz"
  sha256 "692793d0ff53195121ea2838a08b9e66532cfbbf02eb831ca166031efbffa9fa"
  head "https://github.com/eBay/fabio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ea0bc5160fe9663a8ebd3fe764ad8bbb076cf4a7358cdd119a64decbc66a7b3" => :sierra
    sha256 "3f0e13a9ee439c2c726705693c91e2ca7bc543c4798cbcadd4d9876a8b278748" => :el_capitan
    sha256 "65e178e1b9f670e1ae3c962d8dff23dc15b2cede24b03e77561df5404540d400" => :yosemite
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

    CONSUL_DEFAULT_PORT = 8500
    FABIO_DEFAULT_PORT = 9999
    LOCALHOST_IP = "127.0.0.1".freeze

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
