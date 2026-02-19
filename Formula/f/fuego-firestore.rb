class FuegoFirestore < Formula
  desc "Command-line client for the Firestore database"
  homepage "https://github.com/sgarciac/fuego"
  url "https://github.com/sgarciac/fuego/archive/refs/tags/0.35.0.tar.gz"
  sha256 "25446224f1d20d2e843127639450526fcdaa8e3ce03701f4ed9007821cb2020a"
  license "GPL-3.0-only"
  head "https://github.com/sgarciac/fuego.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01bd1cfcb8749d1596df0fcda5c62981949621bb7f73c53fd9bda68b680972ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f86b1ba65cdafa226e82a3fc623eccbab6147244389fb05be05bb5c732439f27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f86b1ba65cdafa226e82a3fc623eccbab6147244389fb05be05bb5c732439f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f86b1ba65cdafa226e82a3fc623eccbab6147244389fb05be05bb5c732439f27"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9d3be6dd8c27d825b5a01a1e2ccce37308f4d77d82df895d36b39e614df16e9"
    sha256 cellar: :any_skip_relocation, ventura:       "f9d3be6dd8c27d825b5a01a1e2ccce37308f4d77d82df895d36b39e614df16e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60075175046d1005b6dd44b7b752c5363fb35802b4bc9a6a91cf3c45eb5221cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f7ddfee2e393fd998a16ebf40f660dff9acef4c88b3b55179de33fb23328685"
  end

  depends_on "go" => :build

  conflicts_with "fuego", because: "both install `fuego` binaries"

  def install
    system "go", "build", *std_go_args(output: bin/"fuego", ldflags: "-s -w")
  end

  test do
    collections_output = shell_output("#{bin}/fuego collections 2>&1", 80)
    assert_match "Failed to create client.", collections_output
  end
end
