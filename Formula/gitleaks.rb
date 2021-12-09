class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.1.2.tar.gz"
  sha256 "25ebf9b42cbca972287ebeb72fcf2e63cb7b427a2fd958b078594132723c8cda"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9beed8e340d4d71b4cb62e7e69b127e53d9f6c7337c24399fc40b7c8a7669f2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b72dc0ec727de53926d3b68f753b85f326e7feea9ee39af96884cd1b72a31f95"
    sha256 cellar: :any_skip_relocation, monterey:       "e8418b92ebb0a2c3a1224ec5463ea0c2874037efe86bc71e3ca23fdd69249f42"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb151def4b9a51beb8441fc4757e041fec4b70660d85b8116e03b053c13e2cc4"
    sha256 cellar: :any_skip_relocation, catalina:       "9abda497440dbe82ba746cd1c78b07f3c96fe51fc315c939633c2dcba33286a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3554cfc31c324bf61dbbea5d9528228d4ebca51757dcd5fcb597b2569ed43af8"
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
