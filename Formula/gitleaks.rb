class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.2.4.tar.gz"
  sha256 "d8030860eacb616d260ddb0d9c19107f2f56662b919273c4e2dca633917fec7d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6d9b3f34e85d26a1f5e10305f71c2252732f78d37d4b14129fcb222eb123df1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f62243bdac5fc2139de9fb2a8147eaa84441bd89a6002d71b7dee932bd46c34f"
    sha256 cellar: :any_skip_relocation, monterey:       "298274900c12f365bfc11290a65724cfe8f97d1acaa702b017f86ee5ce5d5be2"
    sha256 cellar: :any_skip_relocation, big_sur:        "908f71cb3dac086954f20c6b61dc78888e8b5a4214bf40def1262c38892976df"
    sha256 cellar: :any_skip_relocation, catalina:       "87b84dc3bc6ee10f4b3c2293c231335e4b8a0d63eb680e2da5cd8d84007d7a67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "621cbba7dd9e930b89b3d8ea3cfb56bf4982e6470dfa873a2c1c43425c7722a1"
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
