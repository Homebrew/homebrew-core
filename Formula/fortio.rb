class Fortio < Formula
  desc "HTTP and gRPC load testing and visualization tool and server"
  homepage "https://fortio.org/"
  url "https://github.com/fortio/fortio.git",
      tag:      "v1.38.1",
      revision: "fbcebcb68e5799b357fd2f48289b2c69781d5001"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba58f09a91425036cbf36bcbb43998b5f8e24b88c6da6e67a4d6c0f4a60391b6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e09ff2623471dea21b4e8aea88225b8aa77092838a34529431dba68a9fe36f2d"
    sha256 cellar: :any_skip_relocation, monterey:       "b4021113bb904b308d4544440a7d2703f20fc09bd787a5aea3ee6ad0dcad867e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ae1ea446da1af0d63a677652184ec2deda7d16c53c2ee86477900c05f2deee3"
    sha256 cellar: :any_skip_relocation, catalina:       "d56898de8599a87c899a028b8ea856c337189c9ae19f8835a61cba3f78b4e3dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8ac60eda1d5aff59e9d8ade32e2efe2b6b5882b588d8c2beefab29d963b08d3"
  end

  depends_on "go" => :build

  def install
    system "make", "-j1", "official-build-clean", "official-build-version", "OFFICIAL_BIN=#{bin}/fortio",
      "BUILD_DIR=./tmp/fortio_build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fortio version -s")

    port = free_port
    begin
      pid = fork do
        exec bin/"fortio", "server", "-http-port", port.to_s
      end
      sleep 2
      output = shell_output("#{bin}/fortio load http://localhost:#{port}/ 2>&1")
      assert_match(/^All\sdone/, output.lines.last)
    ensure
      Process.kill("SIGTERM", pid)
    end
  end
end
