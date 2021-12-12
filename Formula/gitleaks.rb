class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.2.1.tar.gz"
  sha256 "ab4426b63afad1efd0c46821e88f5f68a7fae8652ccb68d59343f2aab62f063d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0521528da0296be61ea8c9650fe16697a6dc96e67985024b0236773259707a0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f192a71f246685686fb12709b437c97f9d5f1dad527920c301097fcef9dd9884"
    sha256 cellar: :any_skip_relocation, monterey:       "067820ad5cae3b19af6a26f00d559dabe8597889525e30b6b88b341627c88e05"
    sha256 cellar: :any_skip_relocation, big_sur:        "924a028569676929fb330ad35e279ebfa4570c590f1302f484906fe4c75fa955"
    sha256 cellar: :any_skip_relocation, catalina:       "e01db3589333df233fb9081a0cb68931628001dc25b2faebb91f69c2e9366d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4c08f20e0f83db63d981004c5ed170a4d63886eafb5682f8fcee81ea5575054"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "bash")
    (bash_completion/"gitleaks").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "zsh")
    (zsh_completion/"_gitleaks").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"gitleaks", "completion", "fish")
    (fish_completion/"gitleaks.fish").write fish_output
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
