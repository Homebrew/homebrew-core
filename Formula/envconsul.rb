class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
    :tag      => "v0.9.1",
    :revision => "44d6110cf2a8a48e7c6f0d5566e3fe87c455357b"

  bottle do
    cellar :any_skip_relocation
    sha256 "ecd28f505c550a1c56a91214f267c218245a9464c5d7c6d3e32c024b030ce794" => :catalina
    sha256 "20be4db18a8e4845bd225bb240a72e811bc20eb8762923ac7d83c64ccc690a0c" => :mojave
    sha256 "352bbbfaa6595b119d2c40ef9f010b2bfb45eb74184c0db487c384459a7fa980" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/hashicorp/envconsul"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"envconsul"
      prefix.install_metafiles
    end
  end

  test do
    require "socket"
    require "timeout"

    CONSUL_DEFAULT_PORT = 8500
    LOCALHOST_IP = "127.0.0.1".freeze

    def port_open?(ip_address, port, seconds = 1)
      Timeout.timeout(seconds) do
        TCPSocket.new(ip_address, port).close
      end
      true
    rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
      false
    end

    begin
      if !port_open?(LOCALHOST_IP, CONSUL_DEFAULT_PORT)
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
          puts "consul started"
        end
        sleep 5
      else
        puts "Consul already running"
      end
      system "consul", "kv", "put", "homebrew-recipe-test/working", "1"
      output = shell_output("#{bin}/envconsul -consul-addr=127.0.0.1:8500 -upcase -prefix homebrew-recipe-test env")
      assert_match "WORKING=1", output
    ensure
      system "consul", "leave"
    end
  end
end
