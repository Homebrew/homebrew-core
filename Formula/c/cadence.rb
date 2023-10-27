class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/refs/tags/v0.42.2.tar.gz"
  sha256 "5d00ac69732998325d05df6241c3d4ab6b6ca64daeaed701cec9e4b716ab4500"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34a8b51befa27c56a54dbbe0fff3591abc4d2fd012acac289e5657158a8ad4f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e45c82052b82a87e369072f817d7e16db7ce2d007a8b7ac3be73c003b8ca22ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a6d1f236c81fa0d2daf6d332d9ffb63967897a1f58f2abe82120957b1091d94"
    sha256 cellar: :any_skip_relocation, sonoma:         "3463d12bd1b72b4429af76783cd3e9530dc0c44e112a786f2c7e7329f592cf04"
    sha256 cellar: :any_skip_relocation, ventura:        "21105a4fb42c9413c4e0ed22208d6cd1e4b5870067e934efdb1040c4d82adb64"
    sha256 cellar: :any_skip_relocation, monterey:       "d86c3ef53e7844793b77b28ea22beb55935d8347c63c810e3f31fd2ef6b53a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad3c3230739fa9eec1e0b08076773361902ebc5db3898de222a67d32126c6ab0"
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
