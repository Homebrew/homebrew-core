class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.31.0.tar.gz"
  sha256 "9a4a90f15e6b88e8d4742e90d52055f41bd23bd0a8f8e55190aecc0eba11f380"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cb44d228a9b97bca3a2557018a0cf0eab68dc8cac66638e10d0d27c42985806"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9155bbf089e67c5c29a48759b50109df3e63169fd7fa941b96424f69a595f223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56fc81b3eb20a4255e4d7162285f869957801476181828008ce58a9811f0e1fb"
    sha256 cellar: :any_skip_relocation, ventura:        "9c9044a439d770f8a4118d6f06a65f15b8863750750cc20845570ba0c85221b1"
    sha256 cellar: :any_skip_relocation, monterey:       "8745ea267b9cc6507d449b1fd2425c2dc2d0b3594127d3388e59d545c0ef6de2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b44d69d63d157f87d31c2d9df49a307d2fc465cf9bd1f3f3ef7b9aacb6d3fcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f1dd523fa9f7e1e955ecbab4a35700b1f02fa0195f71163af19f1a165591e6a"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
