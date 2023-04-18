class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.38.1.tar.gz"
  sha256 "f7ce00118a757a2807e911bda560a0c131f9e01885d5e5f1daba4e23a60859c9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47419608241e40a393fc4c5993fa694e6a36ade1ac911c1c9e528e4a11794eb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8f61e4cb0a53e20c3610ba39a616de9a96a546cf17a393604228bc177b6e7e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3921eafc98a9cc328325f415ddab2c900abe8df9764a941e8ab8c3dc06e895d"
    sha256 cellar: :any_skip_relocation, ventura:        "a5d653a31583d743b681cf1435cb29a4e515b4b109db9710bc5e82e3cd780498"
    sha256 cellar: :any_skip_relocation, monterey:       "ec1eceb25b4ef16f51e3c0a43a2644e1d8afa83d387660c644accda022405fbd"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7725f766fe2e5fe942a88ce5405a2a696e329f05613dd9dfe50ee33f675506e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f37ad3485546f1d569542a60e0f904d3a2ab68d63c3d2c3ae0719de6f41dd53"
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
