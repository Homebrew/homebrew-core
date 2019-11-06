class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
    :tag      => "v0.9.0",
    :revision => "d14ed8fe00c38009eca840d89896af1a70060ae1"

  bottle do
    cellar :any_skip_relocation
    sha256 "f68d42716c4a89681b27f91ec83fd07c5d2ba63f67417564cc1fb1aa6796826a" => :catalina
    sha256 "47d081464b930c4dd6774d010b5611fe8b012c1e37f1e700bdb51df40b6eed04" => :mojave
    sha256 "7ff8101ec5df97e299533ec309b8c2b79775a0b836c834fc5688049ab180f0ae" => :high_sierra
    sha256 "d381724b4b26753c6f00edf7b5bd107e1571c6f9b33d30931393603f7f56566f" => :sierra
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
