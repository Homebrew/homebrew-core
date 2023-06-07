class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.6.3.tar.gz"
  sha256 "e85b70a700652b051260b8c49ce63d21d2579517601a91d893a7fa9444635ad3"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab8990ed9eeab8dee4b314bcb6189d50f4dc8eebee77de71bc496d4bf8c78b9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93816978aba8f3872e86a77f0ccf1965d92d7377389af58fa12a58c97f23033c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f6bbd95332e4477f3dab83ab33e4ea0eefe9a5545d24b25388e435a14a6baba"
    sha256 cellar: :any_skip_relocation, ventura:        "f05450e71e0044473f85a289d549277edede0d51166a66ff985465f826290d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "ee9fa30859ec7a0e89cd3725759d6f57d039f6a36529abaca6dea2c5d22a163a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ca2de624dcf98c51943d3968c19bbf6fd5e4211826b29eadff3a9bde4d4ace45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee9395e3877ab2abdaa6dddba8405241ca30ce5c0ae56eada5b01e15cdb37382"
  end

  depends_on "go" => :build
  depends_on "consul"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
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
