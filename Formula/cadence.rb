class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.39.4.tar.gz"
  sha256 "73b900d2881073434fed61b4590e38a031403521b17ee3ce9d96cf0c28b69558"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b93abdebf810b4e248107ffc52d61addd81d85756b430c9dd88818909363b8a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b93abdebf810b4e248107ffc52d61addd81d85756b430c9dd88818909363b8a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b93abdebf810b4e248107ffc52d61addd81d85756b430c9dd88818909363b8a2"
    sha256 cellar: :any_skip_relocation, ventura:        "8c89c45df2d85a52d59ad0e4261b925bcc2f3ac6a87b20647f2f590c376404d2"
    sha256 cellar: :any_skip_relocation, monterey:       "8c89c45df2d85a52d59ad0e4261b925bcc2f3ac6a87b20647f2f590c376404d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c89c45df2d85a52d59ad0e4261b925bcc2f3ac6a87b20647f2f590c376404d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4394840916a54200bd319276feddb0c81b3a1967f2fbbb9cf7fd912eed80cd3c"
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
