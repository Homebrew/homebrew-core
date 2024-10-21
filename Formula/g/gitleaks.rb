class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/gitleaks/gitleaks"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.21.1.tar.gz"
  sha256 "84da6099d2d767b02a349281399f0769c107d46012af4af68a9f50490bbcd310"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84c57326c303f08083fd9d4ae4198dcff612e3e20861df3ccd3726b7928fe3f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84c57326c303f08083fd9d4ae4198dcff612e3e20861df3ccd3726b7928fe3f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "84c57326c303f08083fd9d4ae4198dcff612e3e20861df3ccd3726b7928fe3f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "90fc88833043bb7aedd7625eb8258a4d90f6addbba6b6a0911ca003af03136e2"
    sha256 cellar: :any_skip_relocation, ventura:       "90fc88833043bb7aedd7625eb8258a4d90f6addbba6b6a0911ca003af03136e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b478b5240ef47fa39b08aa074f53281b3f1dfaf686f2830e82233bb8794bc8f4"
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
