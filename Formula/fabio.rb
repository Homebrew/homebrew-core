class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https://github.com/fabiolb/fabio"
  url "https://github.com/fabiolb/fabio/archive/v1.6.1.tar.gz"
  sha256 "dafb85fb89a8d23a8edc6e96da54c4bdc0b86fce936fa6378e9f49fa70a04793"
  license "MIT"
  head "https://github.com/fabiolb/fabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d22b3de3f85aea8a2df28ae49222c57a2366dc010247ecdf9d824e470a13dbaa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bca2e5b5ac02f928aad22fe2e0f123ccee4f68fb02a94ef18ed198676c849fcf"
    sha256 cellar: :any_skip_relocation, monterey:       "9de1458ceb4e43d0d6cc71c47190cdb35c536648060a97c1836b7f0b8ee350e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8d272e1512b3f6f9f2d80404861b80006a17f4ee2a58542adf9a517ac24421d"
    sha256 cellar: :any_skip_relocation, catalina:       "47f122ee01e27213de38affc8cc1a9fddcd3581942276324cbeeab1113f98c50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00d00f71de9ed14f4b8b867afd7cc7a9b777f94e5111f53d7c939e53656bed73"
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
