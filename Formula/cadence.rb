class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.19.1.tar.gz"
  sha256 "8d8cc8648010c0d5148c71ada9d31e8bc3c939d897689302a2f77df146bada13"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6b69859be3fd982f728c326221c31753a0455f694763bdee2e731cafcd086001"
    sha256 cellar: :any_skip_relocation, big_sur:       "4286ae1d8fb901fd6837027aeff331cf78a48859ed2b1dda8b9821ee0d86ea85"
    sha256 cellar: :any_skip_relocation, catalina:      "b7e12424470850706159d244a6e315fa1a6204f87840938061dca0343d0e4019"
    sha256 cellar: :any_skip_relocation, mojave:        "08362554c9cb4cdcd762bfe2c5843aa6a23018bf14b32a32b15506ec650ddcb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e26504111649b1f17c167864b7e3065c6b76b411e6dcf3bffad1daf98816691"
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
