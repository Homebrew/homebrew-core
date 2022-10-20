class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.6.2.tar.gz"
  sha256 "9edd6ad52f9e2f6df921e173b6e0913bd1fda34693f0ed07f25c3621b1ffaee6"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e026048e68fbb30c0c9cf919f8a2e999229235cc4664519e74f5a5a54b008b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c67d7f2250abe334b63ae79e7defd7a359a3359c51e5b0a11b18f5cc879ffbd"
    sha256 cellar: :any_skip_relocation, monterey:       "cf14d2e7044c8f3fb921f0164fae9fb003d52cd508a16e16c8bb490948813f6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "2935f766cb066054fe48e3e784ffca0430afb329e023dc9ecfde3e29659b6e6a"
    sha256 cellar: :any_skip_relocation, catalina:       "bab3551ce6db98ad5bc0fce72263cf7adc482ceb10c9e58d1d3dd05e8771c5b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7800877109e1521a02197a3c0ff466cdba791ee011dacf89316edefa9a48717"
  end

  depends_on "go" => :build
  depends_on "consul"

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"fabio"
    prefix.install_metafiles
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
    require "socket"
    require "timeout"

    consul_default_port = 8500
    fabio_default_port = 9999
    localhost_ip = "127.0.0.1".freeze

    if port_open?(localhost_ip, fabio_default_port)
      puts "Fabio already running or Consul not available or starting fabio failed."
      false
    else
      if port_open?(localhost_ip, consul_default_port)
        puts "Consul already running"
      else
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
        end
        sleep 30
      end
      fork do
        exec "#{bin}/fabio"
      end
      sleep 10
      assert_equal true, port_open?(localhost_ip, fabio_default_port)
      system "consul", "leave"
    end
  end
end
