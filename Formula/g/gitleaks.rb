class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/gitleaks/gitleaks"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.20.1.tar.gz"
  sha256 "71d538b29514cce569423ff5e57cddb01e917f8b5a4fc95679240c91ab777b4d"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1ddb7cf673d95efad24de11c7e0e4d338105ce38f6bb9695b7d391de4926e1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1ddb7cf673d95efad24de11c7e0e4d338105ce38f6bb9695b7d391de4926e1e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1ddb7cf673d95efad24de11c7e0e4d338105ce38f6bb9695b7d391de4926e1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9be2dc316ff1fa428e73df4aaeb82943dd599314a0d58d8c87f429cb6f5aaee"
    sha256 cellar: :any_skip_relocation, ventura:       "e9be2dc316ff1fa428e73df4aaeb82943dd599314a0d58d8c87f429cb6f5aaee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bccabdfd4cceb8ca166ed9f12c6880c527163c966f029fd5dc3965a136b08749"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
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
