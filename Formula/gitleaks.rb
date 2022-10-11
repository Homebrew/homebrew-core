class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.14.1.tar.gz"
  sha256 "a6e4ccdccb61b0365d9f594b54c199d31efa60cea24a9a54bc9a2aa006560820"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "674e2726046b28c4c05f4e6b111d322f8af99bdf1ab120fdb9d240c50bad1291"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "764336bda45cd4c182b9a916d3c9efacd12fee90c08e9c1b7712a2c18f063b63"
    sha256 cellar: :any_skip_relocation, monterey:       "00a52ccfd7238b6109e08f6fe7b3b47ea287e52adabd953bdfa0cd5cdfd284e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "19debd7bb8ce86718b3a1ad58ad8f11b3ecc87ea773550a69eedad137373906f"
    sha256 cellar: :any_skip_relocation, catalina:       "6f94e2aaf99e08e72c11a7ed22655515b84b2fe6479cee36c795b017ce22e395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7322cb742fd19b5898cfa6891a8d965a65a525ddaaea765553fd3c1fb43bdc02"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"gitleaks", "completion")
  end

  test do
    (testpath/"README").write "ghp_deadbeefdeadbeefdeadbeefdeadbeefdeadbeef"
    system "git", "init"
    system "git", "add", "README"
    system "git", "commit", "-m", "Initial commit"
    assert_match(/WRN\S* leaks found: [1-9]/, shell_output("#{bin}/gitleaks detect 2>&1", 1))
    assert_equal version.to_s, shell_output("#{bin}/gitleaks version").strip
  end
end
