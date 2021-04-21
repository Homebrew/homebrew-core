class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.15.1.tar.gz"
  sha256 "f9dfc967b9184e57ed68125f0e8e8d7021308916f391977a13e3e8ebe3e6aeda"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "59e6449fe4cb01f3666ff8f6f3e4efa19bea760e9b2b63656e538e6fea015ae7"
    sha256 cellar: :any_skip_relocation, big_sur:       "e8825fc20ec8cbcfe7b496ec9b0008abfb0af4e723e46f1ab804777ee47482d3"
    sha256 cellar: :any_skip_relocation, catalina:      "de6ccf5c2b56567adafe5399c57ca77ee190edbc36ebbd7ebe868d7b1017a0e0"
    sha256 cellar: :any_skip_relocation, mojave:        "555e64b756d92cccb2bd83697af7abe4f3119be10a6cb969f2d80562931e6002"
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
