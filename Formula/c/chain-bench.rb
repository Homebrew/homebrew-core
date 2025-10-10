class ChainBench < Formula
  desc "Software supply chain auditing tool based on CIS benchmark"
  homepage "https://github.com/aquasecurity/chain-bench"
  url "https://github.com/aquasecurity/chain-bench/archive/refs/tags/v0.1.10.tar.gz"
  sha256 "5bfeaacd9cf7d272e88597135bff7f329d455a810aaf2b6a763ac55e18d383c1"
  license "Apache-2.0"
  head "https://github.com/aquasecurity/chain-bench.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "d780b713131c76718e610afb3af9d1a0048adc90e0cfafd230e3903ff3223331"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "43d2b953458c68d99277c0e0ac73cb2f28c89b6257f5bb4cc4ca41c20ba76d1f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7eb818aaaee9a6ac713d2736e6b8daab233d79c28dafe50179e45754e89b3245"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cda1d20699ec3fc5285084a2add027d00aa96216143ece4e56fed47d66290ffb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "141af4bf17cd7756e628464ad2be2b5ec6e4ff00eaa93cb24fac29058caf7eb6"
    sha256 cellar: :any_skip_relocation, sonoma:         "88a17d348438cfaea5db46f351f25e04b999ab8c492746e33a98181f388b7066"
    sha256 cellar: :any_skip_relocation, ventura:        "f216f3a45abcce8098f49f2a9a675942d71782c366650da687042d8cfdd750f3"
    sha256 cellar: :any_skip_relocation, monterey:       "6ca7f92390b22adcace2a4c101c478ba43ab3893344ca91ebfbccf486c33e70a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "82978e4dba20b61bf99f3a39aeec86dbc9c3af3207809a47ddd8bdc0bfa02035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43866b2132dbeded7af6e31783e3d629368d0bf9a0f1c744f4d5c464f11f9122"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"

    generate_completions_from_executable(bin/"chain-bench", "completion")
  end

  test do
    repo_url = "https://github.com/Homebrew/homebrew-core"
    assert_match "Fetch Starting", shell_output("#{bin}/chain-bench scan --repository-url #{repo_url}")

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end
