class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
      tag:      "v0.12.0",
      revision: "24823bde80b386d6f5e4b85c80e17de3e2071e0c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d82ad567bcfdc26801838fa092ce3fc0cb1e20b1aa26588835b6fb9cc105cb18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a16214f8e5a1f56ca711c9c92366e1e8b98a15cea3029b5391e0929934bb444a"
    sha256 cellar: :any_skip_relocation, monterey:       "2ce52fc3187c6e9834735b2c55fe8a214d337b22781300343c527bc5ce10e0bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "f840cd513aa64badff578d8edbd3d08d049f54e97c828e9c46b1dcf9ffb1c1fe"
    sha256 cellar: :any_skip_relocation, catalina:       "3a7f5c2bb6fadca3f7c17b66ef1500656811f9f929cbd1cf42a7994a58d62256"
    sha256 cellar: :any_skip_relocation, mojave:         "9602825e9692a3080ce96532bcf9c530626335824f84afdeace705125989093e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40c7e21d5e090cffc3bb14106a4b51e45a7ec1bd8c5168aa7d5d0cf0509d82e1"
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
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
