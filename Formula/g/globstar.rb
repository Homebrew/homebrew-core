class Globstar < Formula
  desc "Static analysis toolkit for writing and running code checkers"
  homepage "https://globstar.dev"
  url "https://github.com/DeepSourceCorp/globstar/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "d2723d485d3a0baa4e707bfcebdd60960ae6a8928277acf5c0602aac1f050286"
  license "MIT"
  head "https://github.com/DeepSourceCorp/globstar.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6d2490f2fc348c713c7b2b0fff5da014ead85e06b899686e87bba07fb25a085"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a60fa5371a7b96ae3a445ac38cc3bd57bc82e41062c897a12b726655cc40a122"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "351d67820e10c0414789e33901de64cad9322ecead736eed190344f34a141d0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b149581b0925354aafd54731fbf9f621466ca8d5c295b45071f05207691f96e3"
    sha256 cellar: :any_skip_relocation, ventura:       "8e2ee1309a02d22518a620d7873cc020a6652aaaaecc6284817f35b4eef2b6e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7845ae273bfc21394139af8ed7fdebb0006cfcba9c7335af5430c75e52043f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbb1ec871583032673f9633e94f5c2cd1fe482f350c275fc4f0dd3e879678ec"
  end

  depends_on "go" => :build

  def install
    system "make", "generate-registry"
    system "go", "build", *std_go_args(ldflags: "-s -w -X globstar.dev/pkg/cli.version=#{version}"), "./cmd/globstar"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/globstar --version")

    output = shell_output("#{bin}/globstar check 2>&1")
    assert_match "Checker directory .globstar does not exist", output
  end
end
