class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.31.2.tar.gz"
  sha256 "3ffaae8f48fa4340ed04ff4b7b753cb2a3560d29dde72a8f4c92586f17345a7b"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0220bc576246aab72aeff01748f9d4b93c8f33ec1e3b9a6e45f947c12e7b3f10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcb375292e54ea267e39e8f6f83ef60e5c8a9d11848ab1c11a86c1d120e34d7c"
    sha256 cellar: :any_skip_relocation, monterey:       "2a65e2ba49de887cc6a055fc2553e9e99bbbb51da2af13fbe32e1de818d04efd"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbdf13e142f34209597807b82169322e1edcbff8a6c15899d9a7b0989139b2ea"
    sha256 cellar: :any_skip_relocation, catalina:       "7aea679d76317d1757a8804210070028d8110e9657cbeff59c9f81c4a3c27355"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60cc1916b614d53e2eef2ac4eba18aca353bdbe485e02182c1d5719513176693"
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
