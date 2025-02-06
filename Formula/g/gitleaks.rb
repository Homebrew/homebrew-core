class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/gitleaks/gitleaks"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.23.3.tar.gz"
  sha256 "4b49931c46180954fd323eecd1aac1d91a6f742347fa173262ccc6769364a5cf"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47044c063f2e26b0f12000dbb8c4c20d035b15fcdecfead85828817a47482455"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47044c063f2e26b0f12000dbb8c4c20d035b15fcdecfead85828817a47482455"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "47044c063f2e26b0f12000dbb8c4c20d035b15fcdecfead85828817a47482455"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfb1947de146bdc4b999595ea13dc8f39edb718be233974cba6ef4531d42e94a"
    sha256 cellar: :any_skip_relocation, ventura:       "cfb1947de146bdc4b999595ea13dc8f39edb718be233974cba6ef4531d42e94a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "872360b4ec895e249db989d6a78ddaad115ba98764bc14904a2e1249f787cd34"
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
