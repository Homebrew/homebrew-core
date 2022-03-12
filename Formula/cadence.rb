class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.23.2.tar.gz"
  sha256 "b8d60ef07397566edadcda8a829f87cc48352078357db9586e98bc59284498c5"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92fe78f93f1db9b98c50a3f64a1dc7c840f6e708121ce21a0f4f7cb39ab13213"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4ac6e9b349303185ec177647e0f97b4fdffebd0498ecf0f3cac5dbdaa4da4cc"
    sha256 cellar: :any_skip_relocation, monterey:       "3cccec671672d6e3fda549246f0e06fb3470f0bbcbcd508806c9ab8d67c98682"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed368a32ebb740bb98222ac3dc216a1900e4fce9a83757ad4acd355ba8dbeb1d"
    sha256 cellar: :any_skip_relocation, catalina:       "07b8ee83b7c818ddf7d6a586e4d9f8791db0b1685ab0e97cace7d2e2a7f9d722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "297cbd5d9b7c0353de8edc1fe4f265b7e51fb07846411de1629332590ae6a152"
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
