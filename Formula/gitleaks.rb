class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.16.0.tar.gz"
  sha256 "71aace87a76d966a918031588a63127303b375085a39d5b8d2af02105f2118d8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2ad1ff5453c0f899cf11bca877557b426375b594df7b5bb0240f685bc6d972c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2ad1ff5453c0f899cf11bca877557b426375b594df7b5bb0240f685bc6d972c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2ad1ff5453c0f899cf11bca877557b426375b594df7b5bb0240f685bc6d972c"
    sha256 cellar: :any_skip_relocation, ventura:        "9fb4bd1edddaa538e660987d1499b4c1763eda4f4238ae003dee5f31586515d1"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb4bd1edddaa538e660987d1499b4c1763eda4f4238ae003dee5f31586515d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fb4bd1edddaa538e660987d1499b4c1763eda4f4238ae003dee5f31586515d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0abe7255045b0e48b8334d12d6d53c45e000a9e6c9b520bf94d0116015f96ec"
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
