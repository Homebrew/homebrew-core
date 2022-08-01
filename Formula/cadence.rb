class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.24.7.tar.gz"
  sha256 "3bd90cb38364cfec270485d6b55b3af5b7d4a0c7b61eacb213c3b8a6d11f9090"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9baaa2f1dc4c88b44da48d3252ab4f9a0053d973a6187a089850d9674b37995"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5c3250caa42a1c22675b691260961d0fedd4da039c04ca752fac6389b3516f2"
    sha256 cellar: :any_skip_relocation, monterey:       "4636a25c3ac5f7e68a382cd8686dcdb3940dec9089ffdd96325f3c3f41887c09"
    sha256 cellar: :any_skip_relocation, big_sur:        "828d1a632aa0015d86cc90de6b99eece07c8608b2cd9850f2ec0c2dd9fb99f9b"
    sha256 cellar: :any_skip_relocation, catalina:       "4bab1fa1003da42349f7ffc3e716027a8b8a2977562f4f63029971f3b751847f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c23bfb1f294196564d8f73d210a0f4434503eadfed01dbd327d181523d403a78"
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
