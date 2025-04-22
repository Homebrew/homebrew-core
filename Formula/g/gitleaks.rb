class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://gitleaks.io/"
  url "https://github.com/gitleaks/gitleaks/archive/refs/tags/v8.24.3.tar.gz"
  sha256 "1cf78443355066cb056d6fb5fc0ea695d2cd06dcd8e33a3c92999fb340c67cc7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe18ffa5e89d131a8efcbbc086d689ce41b000f63f769df3698f6955d5284d77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe18ffa5e89d131a8efcbbc086d689ce41b000f63f769df3698f6955d5284d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe18ffa5e89d131a8efcbbc086d689ce41b000f63f769df3698f6955d5284d77"
    sha256 cellar: :any_skip_relocation, sonoma:        "f5bea6d59c170d9f4a41b9f41de431fd97f816fcbc25d6443272f5aff9db4c6c"
    sha256 cellar: :any_skip_relocation, ventura:       "f5bea6d59c170d9f4a41b9f41de431fd97f816fcbc25d6443272f5aff9db4c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6dda47a73dc6b8117ee6d2cdcc6dfdda3d9b4909ed9cfbdd665cda43c86ffa2"
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
