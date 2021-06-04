class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.16.1.tar.gz"
  sha256 "1e54e4eef29c3c445bbf245701e78a5c88493f5d5ede3389b81018c75dea4c89"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b0c6cdd2d2eb6886ef4948e572f1c8fc9e0cd8996aa570e2fc5e484f53597194"
    sha256 cellar: :any_skip_relocation, big_sur:       "ba6b63c5c097815269ed8e66f4e5e1f80d431eb437fd6dc34f9286000851c351"
    sha256 cellar: :any_skip_relocation, catalina:      "61c8d0de175cd5318ca4d2d6fa7528dc106d26a28870190567ff20502434a042"
    sha256 cellar: :any_skip_relocation, mojave:        "6c3fe170b88f5a8009a0a1d6db7b205a6e9bd14219c708e38ffe967e4aa9a95c"
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
