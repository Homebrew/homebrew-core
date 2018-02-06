class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.5.7.tar.gz"
  sha256 "c33cf4f5e3bf7c9ce2ef634cccebed01d1f0c6e1f31759111db7d94f7a0ceadb"
  head "https://github.com/fabiolb/fabio.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "066b27c7f2cb285cd864632817cf614ea4c07a9f69c6bcb61034013189056a64" => :high_sierra
    sha256 "cd911cd0490c4f5bf4a4241bfd61d783c6317ffe1972131e3b4cd0b769f78aff" => :sierra
    sha256 "6c4581af8078e11eec3a1832729d45b77bab9fd8a14f18c323b7b131022eeea6" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "consul" => :recommended

  def install
    mkdir_p buildpath/"src/github.com/fabiolb"
    ln_s buildpath, buildpath/"src/github.com/fabiolb/fabio"

    ENV["GOPATH"] = buildpath.to_s

    system "go", "install", "github.com/fabiolb/fabio"
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
