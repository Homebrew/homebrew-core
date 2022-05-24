class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.6.0.tar.gz"
  sha256 "2a3a678a3ee7a5415512a1b3b799352186859f5d4dd50330d1117b21a643c398"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b80a286a30fac7a23bece1d65c150cc6fc1c2eeeda3766c5c93c6c8ada8ef20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0c59dfa1ba7258ed97881ca221973703b31eb6de8fb0deed61661aaf3458bd3"
    sha256 cellar: :any_skip_relocation, monterey:       "397c08ca7a84a394aa612e7150b8b74a7383c39924c682f9c881fef35bf4f07c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4557d5ed59085c4bba46bba43edb6350a6c6b845bdec43ecb14c135fac046cec"
    sha256 cellar: :any_skip_relocation, catalina:       "8024546a68136e01f7283b5d9ae216ba405fd2867a34bf4dda47e56a5910cd5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e136b546ee472869e27a7bd8ee4584a79ac953a5370d01aaa1b2555dae148c"
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
