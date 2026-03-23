class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://gitleaks.io/"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.30.1.tar.gz"
  sha256 "e90fb266d75837e75894c778bf594ab8e2787f12dce5a62651f21b893eaf9abb"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea543daa28d39acc7af3aab4491ef53d62c0402b540d087008ff4dce7e2484b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea543daa28d39acc7af3aab4491ef53d62c0402b540d087008ff4dce7e2484b3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea543daa28d39acc7af3aab4491ef53d62c0402b540d087008ff4dce7e2484b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ad6e2b32842b821be789b15ded39cddfe9b886c9a690466e616b330d927044e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7e4678071fba37d6dbc010e745b880477476e486b1e6141af18148655876b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78b43afdf14a05c5df07b73aeaf63ae56b784c905f057411a43ee8fde40fe5d1"
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
