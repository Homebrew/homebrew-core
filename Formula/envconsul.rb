class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul/archive/v0.7.3.tar.gz"
  sha256 "7152d73818c3faceac831c6ffae6e01c2f3a6372976409d9d084130ffcea35f4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "4d1562d58c5d242d2dce65cf8ea611531cb2f26d10cc1a86ae226554152e7727" => :mojave
    sha256 "41dc101f3ba5ecf98360e770b96f147811f9fc5d4a748ebe3a19f46dad102b9d" => :high_sierra
    sha256 "beda6aec1024ba24a35c671881c4640295bbf7c82796bf7a470b006a4562a460" => :sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/hashicorp/envconsul").install buildpath.children
    cd "src/github.com/hashicorp/envconsul" do
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
