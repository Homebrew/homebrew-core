class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
      tag:      "v0.13.1",
      revision: "3111d811578b1c7f6c8af032a9d97234621e2b0a"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae3da5d88d84ca10de1d8aba2e729c3003a8471ac55663906cc5de0aa346738"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "765b7246012434cd3f226cfc83158b02c2e0d32cb05f544b074b37d0e11ed13a"
    sha256 cellar: :any_skip_relocation, monterey:       "c552f2ed9f026eebfb281aeedb8c9ae593e8e7ff97d99a7451c45e5f46c66be9"
    sha256 cellar: :any_skip_relocation, big_sur:        "870fbc163cfcdeea7abdedd3a974d3a890694b4eb3d14194c7a34df15cd990cf"
    sha256 cellar: :any_skip_relocation, catalina:       "e63efc1337364669933ff9bc274f096d503c1d750360db683672c988ee00edfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c478975d58b8da6790ee34e3fb3e99a0b704e286fa7bf30dddc3b680bd436d7b"
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
