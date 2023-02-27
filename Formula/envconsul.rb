class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
      tag:      "v0.13.1",
      revision: "3111d811578b1c7f6c8af032a9d97234621e2b0a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4da4f61b039ec8ff4cd8eb37166a9b337b4bb68d194da5897257a005f2a1dcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4c1b48f0ee4bf5ae510177ce3a9e5c785b7c515a21efc1383d93b03525634ac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f75ee73c50f5050be219e82e9b00e7db5021e0a842cdaf3fbb97f558b9cbb6bc"
    sha256 cellar: :any_skip_relocation, ventura:        "9a11bddb7fef6952f459fc3cc7aa20288b2d5371c00a68a5f51cc3f476308ce6"
    sha256 cellar: :any_skip_relocation, monterey:       "bab521f33f53f6e438ffb6ec0242b000cb77afdc6f2aa169db4f96522b6b84ad"
    sha256 cellar: :any_skip_relocation, big_sur:        "8bf147b061f72477077fed4278be1ae0a95db5ad7422f96536925e0256e343e0"
    sha256 cellar: :any_skip_relocation, catalina:       "b7fe23483d90a0556e10fd933b663ed17290672a878ead5b772dbadc1fed01fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b1e427c2757e0aa96f32794e3d89c4cd5cd6d3d080c2786d86cd966d46915ac"
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def port_open?(ip_address, port, seconds = 1)
    Timeout.timeout(seconds) do
      TCPSocket.new(ip_address, port).close
    end
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
    false
  end

  test do
    require "socket"
    require "timeout"

    consul_default_port = 8500
    localhost_ip = "127.0.0.1".freeze

    begin
      if port_open?(localhost_ip, consul_default_port)
        puts "Consul already running"
      else
        fork do
          exec "consul agent -dev -bind 127.0.0.1"
          puts "Consul started"
        end
        sleep 5
      end
      system "consul", "kv", "put", "homebrew-recipe-test/working", "1"
      output = shell_output("#{bin}/envconsul " \
                            "-upcase -prefix homebrew-recipe-test env")
      assert_match "WORKING=1", output
    ensure
      system "consul", "leave"
    end
  end
end
