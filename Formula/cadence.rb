class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.12.11.tar.gz"
  sha256 "a6331d76336793d678bab79b384169c1e9ea8de0e70d80a09a51a05c0c3d50d8"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4afe9551cd2caf4997bbaca79b74e0797406809623bf8a33f207ecec639962f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "77f7e857bcaa00cb5b9cf585e80a66ade2e17a0710d78bec1964787a55753ab1"
    sha256 cellar: :any_skip_relocation, catalina:      "d9c60a32a8a67492f2a2227be82267f937ea71608d32652d99565d4f89523a34"
    sha256 cellar: :any_skip_relocation, mojave:        "b66e33c060f7a8691abb19267b69c7c840c3fee29afc8398cc2975770fd9d591"
  end

  depends_on "go" => :build

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
