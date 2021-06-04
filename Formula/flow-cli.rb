class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.21.0.tar.gz"
  sha256 "17f52272bafc48a9aeaa1d5043e64c71f4bf16744ec5ffd98031ea5ff512f09b"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a337419099cf954cc146024cd79277506f53c197f57800b5488107d95c7b17ce"
    sha256 cellar: :any_skip_relocation, big_sur:       "3173dd42945061d3b7f8f8241697d8356520ed3c76bfe5cc09eebc9c8e987514"
    sha256 cellar: :any_skip_relocation, catalina:      "aa238597fe91719c4e421a691a0c188d96656fb72fde8c2a14bdf5d51538b93e"
    sha256 cellar: :any_skip_relocation, mojave:        "b74247679c86e9b132b7be2da6e3c3d1c8b49e726b33fb37a31d287739372591"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
