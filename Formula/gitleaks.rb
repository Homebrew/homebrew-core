class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.16.4.tar.gz"
  sha256 "2348f4f7287cc3e3d0dd3e83f288fea8bc3f62e7050275ee51882b2051435b63"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73ddbd89f984b56cc6c4c4bc447445131e8f36c783cb59a577c73848d51e850e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73ddbd89f984b56cc6c4c4bc447445131e8f36c783cb59a577c73848d51e850e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73ddbd89f984b56cc6c4c4bc447445131e8f36c783cb59a577c73848d51e850e"
    sha256 cellar: :any_skip_relocation, ventura:        "e13e28d7de4460e6aff56d3280a19e0336b4ed893615446997158f8445eb46a8"
    sha256 cellar: :any_skip_relocation, monterey:       "e13e28d7de4460e6aff56d3280a19e0336b4ed893615446997158f8445eb46a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e13e28d7de4460e6aff56d3280a19e0336b4ed893615446997158f8445eb46a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ea156188f2dfcd2ef478c56286faa572a95a9eaf2720f54fa5a531ba843303c"
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
