class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
    :tag      => "v0.9.2",
    :revision => "e00ce74043ac1204566ece60f12919c8b56467f3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5b8bcd4a1b4b94e6b9d499dec21023de08173377a0da7ad0202794fae8eb4dd8" => :catalina
    sha256 "b41595fbf6ff4edca1fde5712340cfb3f250108806a93482740d71a3c4c2a62b" => :mojave
    sha256 "12d804dc683b02047a72c1ba28ea2882cc38095cda3fae84fe5dbb93deb06c8b" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"envconsul"
    prefix.install_metafiles
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
