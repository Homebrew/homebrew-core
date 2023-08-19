class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.40.0.tar.gz"
  sha256 "557efb16797764f1543382741b5759d28b0074517a61f31f2aa0626eea66b13d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "414022c9eaf064eab220906401b24f53b37407dbc0d236a711bdf156290f751f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "414022c9eaf064eab220906401b24f53b37407dbc0d236a711bdf156290f751f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "414022c9eaf064eab220906401b24f53b37407dbc0d236a711bdf156290f751f"
    sha256 cellar: :any_skip_relocation, ventura:        "fad87266a75fb8aa8c1a226556a8673b5c3998579c492b0850db03b5ee45f2fb"
    sha256 cellar: :any_skip_relocation, monterey:       "fad87266a75fb8aa8c1a226556a8673b5c3998579c492b0850db03b5ee45f2fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "fad87266a75fb8aa8c1a226556a8673b5c3998579c492b0850db03b5ee45f2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac0f4e368d5eb80c3b740426cd4cfb44b7b82878faa76df32ebf42c40e2f12e2"
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
