class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul/archive/v0.7.2.tar.gz"
  sha256 "c2b2723089f82f7b1623676fda8d378795bf87b4dbc6d4b297e5fc27aeab0aca"

  bottle do
    cellar :any_skip_relocation
    sha256 "a318db92f566f0d21aea9310394ce038ebc45e3a39e7010388c05e6481108f50" => :high_sierra
    sha256 "f55d0bad4103ba982bc4d6bc5ef5a8eb82ed253d1d619a1fddb30149454b2baa" => :sierra
    sha256 "0b3b4bfb1dd3dcf69cc0647ca2fca8864fa316e984dd201913f363dff85dba74" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "consul" => :recommended # only used in test

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

    def port_open?(ip, port, seconds = 1)
      Timeout.timeout(seconds) do
        begin
          TCPSocket.new(ip, port).close
          true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          false
        end
      end
    rescue Timeout::Error
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
