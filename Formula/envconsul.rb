class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul/archive/v0.7.3.tar.gz"
  sha256 "7152d73818c3faceac831c6ffae6e01c2f3a6372976409d9d084130ffcea35f4"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3afd485ef223e959379e56774968260824b561a3be85328abcf5179f4d67839a" => :mojave
    sha256 "bcc86e79f07b429a1f11e23b0dec1d359fd5bbed13f7aba1ce300c2da8f6e637" => :high_sierra
    sha256 "6f66466edce5064c839d4328b819ea5e915474512153e72beea08b5846cb2b77" => :sierra
    sha256 "be7343c9cfa1c58fb65ad6eef20c99f27cd0a5dcfc5aba5851593c534e41882c" => :el_capitan
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
