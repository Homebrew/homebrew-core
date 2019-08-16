class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
    :tag      => "v0.9.0",
    :revision => "d14ed8fe00c38009eca840d89896af1a70060ae1"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9cfc3f576580bd6e394c78785dec30f099fdf4bd6f9651356532c686ef881eb" => :mojave
    sha256 "fd5335ba1720e02e7eb513ee5c3ea202e112ee3bb6d802229967128180ea75b4" => :high_sierra
    sha256 "8b5b47937348c433759370d36217a06581691b5392f9576302f6c62a75e62163" => :sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    ENV["GO111MODULE"] = "on"
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
