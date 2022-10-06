class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.28.0.tar.gz"
  sha256 "c18f74d4a17b13262f8e7ab372d3a4833b2d2ca2747a12db12321c94c769fb7b"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b5ebba91349b19b5de0339a04d94fe056536a928fb90c0faa0b5992fd38ed9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1a048ff9c432462d1333484aae4bfeeb35446facc2729b41b27f0539b519277"
    sha256 cellar: :any_skip_relocation, monterey:       "431372c0e1a204ee8c0f6419b4c3c9e15c6151eb6feaa13164fbdf6ddf8a5269"
    sha256 cellar: :any_skip_relocation, big_sur:        "793d6e4ab3abb647ebb24690ace307c776d248d406f457b406d6cd5c72f9fad3"
    sha256 cellar: :any_skip_relocation, catalina:       "4ae37c12938b8232426288530d208a556fc4f4f9040bdc6fd55b487af4ce0f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8d7413e7e16d41eca6c3f822b028a15d38a9b92900c4ad483e24bd014d98817"
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
