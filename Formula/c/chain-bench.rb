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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd785591312edf03b12e224b5459291c5b5e1bcdaf42cf0851f3b15eaa970fb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd785591312edf03b12e224b5459291c5b5e1bcdaf42cf0851f3b15eaa970fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd785591312edf03b12e224b5459291c5b5e1bcdaf42cf0851f3b15eaa970fb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d95ef4ad254825949c945ee60e1090e2ef105c6ff82576bce77dffe3c9c8f60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c872a4288022250f8eda7a5c93025c2c5071866485754d7d097099746adf810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b5b9003c38b13b95a45d30da1d996afe373ec223928a9b5db1b9925b9d45b7d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X=main.version=#{version}"), "./cmd/chain-bench"

    generate_completions_from_executable(bin/"chain-bench", shell_parameter_format: :cobra)
  end

  test do
    repo_url = "https://github.com/Homebrew/homebrew-core"
    assert_match "Fetch Starting", shell_output("#{bin}/chain-bench scan --repository-url #{repo_url}")

    assert_match version.to_s, shell_output("#{bin}/chain-bench --version")
  end
end
