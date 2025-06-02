class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://gitleaks.io/"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.27.0.tar.gz"
  sha256 "7be328508fc73b6e530266741b518e1a685f70e441e581483bf6304d34d2b02a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf059cd99960fddc0e69a7608302e4ec7157222faaaf166d085b25ec135a68ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf059cd99960fddc0e69a7608302e4ec7157222faaaf166d085b25ec135a68ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf059cd99960fddc0e69a7608302e4ec7157222faaaf166d085b25ec135a68ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "08e2e6df1faff84f91c4d7638056fe5946dd50ef2909ce8a03f89a97024a500e"
    sha256 cellar: :any_skip_relocation, ventura:       "08e2e6df1faff84f91c4d7638056fe5946dd50ef2909ce8a03f89a97024a500e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f0aac08450870dd6d53273d3a38cf6135ef5ef0d53d3516f7523375b2d90346"
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
    assert_match(/WRN.*leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
