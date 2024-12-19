class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/gitleaks/gitleaks"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.21.3.tar.gz"
  sha256 "8a5a73bab9ac2567ef0df152b98b39d7dfd5356274afe0260b6f16fb787e5172"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03c3a9d5df8b3ae0b14e88297cd15628f731c6f3a8c8b708b667b5978439af0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03c3a9d5df8b3ae0b14e88297cd15628f731c6f3a8c8b708b667b5978439af0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "03c3a9d5df8b3ae0b14e88297cd15628f731c6f3a8c8b708b667b5978439af0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f244d0d43353d2ba5039cacbe95e08765284dc37eba30c537e1ee6a9d5cc242"
    sha256 cellar: :any_skip_relocation, ventura:       "5f244d0d43353d2ba5039cacbe95e08765284dc37eba30c537e1ee6a9d5cc242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1fa6d65e86bb9fbd08cc0d0a56f273710082bd17375f8b904c0e5c4b932f1f8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeef61dc214e36cbc4cee5eb6418e38d"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
