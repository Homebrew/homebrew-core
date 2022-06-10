class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.24.2.tar.gz"
  sha256 "7da4d275b75310418f70effae3195b27736d6eaa44599995d44cc9a57728195f"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b49b566f212097ccaf4c951e893a004d855b8fb82f3d7f99003841c77a0b137c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d74dea4c0e19942f37918df7b60e81645a21c06280fa8abefb32e8f3419f1f1c"
    sha256 cellar: :any_skip_relocation, monterey:       "45ba5ef7dc821fdec4848412c2f2c01336ef20d5afa518dad32bd4418b66a145"
    sha256 cellar: :any_skip_relocation, big_sur:        "d3ddf6d423a7ac84dee16681bc78404e7446a612c29a6f4fcd7590528b457ee2"
    sha256 cellar: :any_skip_relocation, catalina:       "631e58a000e668b48dd143b0c586b992a39d523f4a8f3ac9390498fff84e0b4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c7c831df0a7dced92d66fd059c341ed9268932de46ae8122ab00be51591acb6"
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
