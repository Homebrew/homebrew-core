class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.39.12.tar.gz"
  sha256 "e65db7c1804a039eac775c35bb957a301d42cce34552d7fb765832bf1975c701"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e67f290cb559099b3b52c9b2d21c975ceaa4655635b645cfc4f576da9e29e78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e67f290cb559099b3b52c9b2d21c975ceaa4655635b645cfc4f576da9e29e78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e67f290cb559099b3b52c9b2d21c975ceaa4655635b645cfc4f576da9e29e78"
    sha256 cellar: :any_skip_relocation, ventura:        "b20d3ddd664dd9c1b0ab11d86649e886b63b412add9927e706a24022fd9e3cfd"
    sha256 cellar: :any_skip_relocation, monterey:       "b20d3ddd664dd9c1b0ab11d86649e886b63b412add9927e706a24022fd9e3cfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "b20d3ddd664dd9c1b0ab11d86649e886b63b412add9927e706a24022fd9e3cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "229d9aa3f37ba4392f551a46f8262ed531adb869c441d1967318994ec5f1ff39"
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
