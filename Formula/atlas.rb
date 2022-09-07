class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  url "https://github.com/ariga/atlas/archive/v0.6.5.tar.gz"
  sha256 "c98d2410d373325aabf3e8140cd4a16cf72bade4029cb921eef7807cc04a78f9"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad8a4c88f480d2926e873d762bc93a7d270ffea585f6dfc3664c89f7f82af80b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdba659118022309a1bfbe0a433f5052a46a41b98074387d5d817e9bf5f85a21"
    sha256 cellar: :any_skip_relocation, monterey:       "acbea82ecc6b253e9aa47b6e1ddfa07189d5bb4bc07c62e9f91bb3945c84d03d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f771f6d3bf0161037eaaf080aa668042e4ef5598c7c651c71d8d7eb269a02603"
    sha256 cellar: :any_skip_relocation, catalina:       "4ed5a0082506c91e89cc96cfe04511bdd6ab4f843ec56d5e0f3a2db66c280a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "948e60814e5047b97a170b73dedbfdfe74046e1596f329ab24130c2e8a1b3628"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
