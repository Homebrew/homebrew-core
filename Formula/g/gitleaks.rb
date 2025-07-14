class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://gitleaks.io/"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.27.2.tar.gz"
  sha256 "6f1715cbd9f4fd0d96d6a7dfbc26c3a46d5e5627f13cb8ec18cedf966bdf653a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2747961634d51e7f80a2cbce3a0c744f67c9668e5177bac947684f61c066be7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2747961634d51e7f80a2cbce3a0c744f67c9668e5177bac947684f61c066be7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f2747961634d51e7f80a2cbce3a0c744f67c9668e5177bac947684f61c066be7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d410c52ebb8dc628cda0cae58698ab8b5fdab3d831acc123f1edf8d2818cff8b"
    sha256 cellar: :any_skip_relocation, ventura:       "d410c52ebb8dc628cda0cae58698ab8b5fdab3d831acc123f1edf8d2818cff8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08e131d316425a206dab7b92227570342ba94b6af6937c5507cb59b53931b584"
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
