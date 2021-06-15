class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.18.0.tar.gz"
  sha256 "6739b8b79367847885a0ab0e51f3ee5b2018cbd270fe494fe9b2368acfbbf223"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "77e7241d8de136c8c3b70704bebb12be8987df6f4ba172af139fc7dbe4903f95"
    sha256 cellar: :any_skip_relocation, big_sur:       "8708677ed9af143aa97a7b7661b6d4b478a34a1ff302c02ea48c823d46c2f591"
    sha256 cellar: :any_skip_relocation, catalina:      "670d1028f5685c84b471a59a0ba08bfa14cae019f9e68eba3a13758aa07417c4"
    sha256 cellar: :any_skip_relocation, mojave:        "60ea85f0be9e2a9aff96a51fc49f819f88ff2f6f1616cfe004a487b279f9cef2"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args, "./runtime/cmd/main"
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
