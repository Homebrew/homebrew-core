class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
      tag:      "v0.12.1",
      revision: "265f933f17eb918e38b24fd1a7b1eab1fc723df5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "898985bf53d71aea16b24cb485e546891eab5d44004fbc7f4ee5e973cddd27cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29e0145aba0f31eed7a338270691de3b3169be26ada9c6e310f0e0d304e7f4b3"
    sha256 cellar: :any_skip_relocation, monterey:       "12f0d468fcc3ed95048f85333142b0ad3c7818a854c2376cdaa6c4010933ec2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "51678e734960789113eb9a5f006b51c6dda61e34344263ed9fd3c960cf3afd1b"
    sha256 cellar: :any_skip_relocation, catalina:       "01f9234248e8634e2b010a6cde300d2c1c42d80218b95ade22ff003b71b527f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b05d32bffd8d9435e52402079c04c01b69ab92f15bd7794519c8d9679b1641e6"
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    begin
      fork do
        exec "consul agent -dev -bind 127.0.0.1 -http-port #{port}"
        puts "consul started"
      end
      sleep 5

      system "consul", "kv", "put", "-http-addr", "127.0.0.1:#{port}", "homebrew-recipe-test/working", "1"
      output = shell_output("#{bin}/envconsul -consul-addr=127.0.0.1:#{port} " \
                            "-upcase -prefix homebrew-recipe-test env")
      assert_match "WORKING=1", output
    ensure
      system "consul", "leave", "-http-addr", "127.0.0.1:#{port}"
    end
  end
end
