class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.20.0.tar.gz"
  sha256 "8cde15afedde078cc1fc9499a4b3acfe4222e676d565ad2e36d0a166b31f932d"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6fa852754c699ba861093a3f41b49a48f029f825272edd50acb989768c7d4d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e51630daf3696a9ffdb6c6e0f286a1465eb8df6681860e3912c43ae6e9e99aa"
    sha256 cellar: :any_skip_relocation, monterey:       "eda93f746cabba999b63ead2a7184cc7ec9e0d3b206e79b7c8a0ae98c0c8b736"
    sha256 cellar: :any_skip_relocation, big_sur:        "4267c7f393824535d4fd30d287158528535716f7e5539f402b0bf6a12df810c8"
    sha256 cellar: :any_skip_relocation, catalina:       "347c02ba5e0835ca5fa6738bdb04b599b1cbc87aefcfcc49d7b55841a53217ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47022f201f34a61672c49c8f9e39868ce667b05d6b7f5451b27e88474a047ad2"
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
