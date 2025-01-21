class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/gitleaks/gitleaks"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.23.1.tar.gz"
  sha256 "2a0157b103d4fb372b613de96ac7a8c0c534852b4e8b712dd5b725e85ebc2efa"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d79c8f7a919b28755c181340f2c4c99cd0f6f949c1435952d07675f23c782ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d79c8f7a919b28755c181340f2c4c99cd0f6f949c1435952d07675f23c782ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d79c8f7a919b28755c181340f2c4c99cd0f6f949c1435952d07675f23c782ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "30bc8d2d9968cccd1fe9354d9b5995e27b19c8e19a1b74048709922ef1f6f67a"
    sha256 cellar: :any_skip_relocation, ventura:       "30bc8d2d9968cccd1fe9354d9b5995e27b19c8e19a1b74048709922ef1f6f67a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1b69ab462a08b21ce360e887f7276416b222674e05e6de2cb735ce3f6ae957"
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
