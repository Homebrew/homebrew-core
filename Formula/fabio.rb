class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.5.15.tar.gz"
  sha256 "19dcd4d8c6e4fe16e63e4208564d08ed442a0c724661ef4d91e9dbc85a9afbe1"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4309d65486b5f6552f3142cd941563999d376a689c0a23681d199fa6bc037d07"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24a70802040a86892080a151eafa1304f5b1a61da347f7a1cd5565ae73516477"
    sha256 cellar: :any_skip_relocation, monterey:       "ff1b2d576c9ee56e25a8a672cefb99d53623393c87386752d87f037761282910"
    sha256 cellar: :any_skip_relocation, big_sur:        "64a7ae7497bc62f44ad203a43b4e0c9bbcb1bad020cb876422bd0d746f6d8bcc"
    sha256 cellar: :any_skip_relocation, catalina:       "ffbae8584c9186bb63a761cc52aafd82fb90fd3ec35bce7b9fe81ffa0baf5b0d"
    sha256 cellar: :any_skip_relocation, mojave:         "813e3edb76153f73dbd94b5291213a7584632f43a6bc9d4a8ef4deab6e3f96d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1acc04acdcfaba5e627a62d9257c4ddad3d3dca9169720b9b6e976a38bc3a165"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
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
