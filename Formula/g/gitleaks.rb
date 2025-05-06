class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://gitleaks.io/"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.25.1.tar.gz"
  sha256 "f39df96c18cbd03a38a882cad5e8ae6699d49f374cd63b540c4b5a8cf06beb05"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "011a1f3cbe5fc44b77398d53715dcd48f039e852b00f434ec8a9dcc54a3ac245"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "011a1f3cbe5fc44b77398d53715dcd48f039e852b00f434ec8a9dcc54a3ac245"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "011a1f3cbe5fc44b77398d53715dcd48f039e852b00f434ec8a9dcc54a3ac245"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7acf025312d5a3bb196c3bd353257e809001e9e3771e045d7cad02316be4ca6"
    sha256 cellar: :any_skip_relocation, ventura:       "d7acf025312d5a3bb196c3bd353257e809001e9e3771e045d7cad02316be4ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "852a657de770fd735ef800b87e7a24817534dade993ecb08bd79595e39a9e62e"
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
