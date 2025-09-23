class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://gitleaks.io/"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.28.0.tar.gz"
  sha256 "c681af8aeacacf9d14f7ad97d534cf087f6d2d6fbd50dd02020b0f929b7a1c41"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb2dc7c6a93a702793e0533d0da02286477a83c70d3ade63b1d65c7d8921a14b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd1443521907f98711778ff09f29bc66fd711fb17ba89df2ff09814466617cd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd1443521907f98711778ff09f29bc66fd711fb17ba89df2ff09814466617cd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd1443521907f98711778ff09f29bc66fd711fb17ba89df2ff09814466617cd9"
    sha256 cellar: :any_skip_relocation, sonoma:        "06c83ac2bbb8d9744479a77e74c752fbcf50a14ed5671a60704241d0a89022d7"
    sha256 cellar: :any_skip_relocation, ventura:       "06c83ac2bbb8d9744479a77e74c752fbcf50a14ed5671a60704241d0a89022d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8c985d9b8ba59fdf4d9e42c4e52aac2189de3a1bbdeae500e28225e41a3b3b9"
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
