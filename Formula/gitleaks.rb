class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.16.1.tar.gz"
  sha256 "203269c7eeda5129ae07536242e3dba8c850868582fb58827d81a09a0969233b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "664cece9919f6817b0381f5c28628c70c1ea22a2183197d533927df8ff697bd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "664cece9919f6817b0381f5c28628c70c1ea22a2183197d533927df8ff697bd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "664cece9919f6817b0381f5c28628c70c1ea22a2183197d533927df8ff697bd5"
    sha256 cellar: :any_skip_relocation, ventura:        "00ddfe41b8ad03c2aa0cc65397c8a08a8fac3fdec7c4515eafebeda6d4c4583f"
    sha256 cellar: :any_skip_relocation, monterey:       "00ddfe41b8ad03c2aa0cc65397c8a08a8fac3fdec7c4515eafebeda6d4c4583f"
    sha256 cellar: :any_skip_relocation, big_sur:        "00ddfe41b8ad03c2aa0cc65397c8a08a8fac3fdec7c4515eafebeda6d4c4583f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be56fdfcebfc1995cd6119fdb57f4226c1fbd85a59b99b2943d8bac83fc05669"
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
