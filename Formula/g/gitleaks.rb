class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://gitleaks.io/"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.30.0.tar.gz"
  sha256 "606b3ce45d1e64d28ac7729ee03480a8ee2c5e5a5c5122844bd9516f3cc1bcf3"
  license "MIT"
  head "https://github.com/gitleaks/gitleaks.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a25a14d9aee2d018bc591993a0d711763f646dfb2470febbcbdac35fc2702e18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a25a14d9aee2d018bc591993a0d711763f646dfb2470febbcbdac35fc2702e18"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a25a14d9aee2d018bc591993a0d711763f646dfb2470febbcbdac35fc2702e18"
    sha256 cellar: :any_skip_relocation, sonoma:        "01e8b3aec5550aa8899176fb08566b6415d021ad6aedf1e474cea029291ddb8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77faf8e34c459370948485c9e24acdcd19b9c88f9866952e969a19ecf00f3ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb7706128893697dae8df92801a9303f2c6658782c23ceb2b3605667a293c6d2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/zricethezav/gitleaks/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gitleaks", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"README").write "ghp_deadbeef61dc214e36cbc4cee5eb6418e38d"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN.*leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
