class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.24.0.tar.gz"
  sha256 "aeddc6ffbb45aa85ce76a0aa7b0a7eb68cedf7f7ba92dc8ca2f9ae8c48649ba4"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4166bf0ab505108b063fed9a1d16803a2e1d835b7666f1ef674c1c7b4620d8fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "feabeccb3a04a43ec0844de8859c0daeb91fa649065e99041118bf6c06843867"
    sha256 cellar: :any_skip_relocation, monterey:       "4f700a9a6b0f1319cbc310e50605757245b5625a82b3090fd93aef8dd3b6a33c"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b79c80b9b1ae79a7e6522d9dc1dd4c8cc6991825c47fb4183f3f79e54b11a7f"
    sha256 cellar: :any_skip_relocation, catalina:       "d59a560ae7f5101c4b1bc1bb013dc539fd0a79559cd3632e117852a7b8ca45a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e987973d4d4cab8cb6ecf89c5b0095a6aa6fd2d8caced6131f083fece5de6d8c"
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
