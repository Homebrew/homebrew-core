class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.6.1.tar.gz"
  sha256 "40aa9440bb8dc369f10a3e87614cf0cd1c7722ce6d8bc12b814d7793ba0766ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b34355c4d77b0196d2c25a27ee19235fe1a880aeee9c2d45fe6ea74b28b9f460"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "faff7749465e80982fa4511c35cafdbfb8c0936385fdf53b1bb49a401270123f"
    sha256 cellar: :any_skip_relocation, monterey:       "ad420ed09c8dfe382c87301fbb5adf0b7910793cf3b8f207c5ca312171cda5ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "366723e5465938c252e2a86a35ec2aa793f108364214ac02a49921efab40af2d"
    sha256 cellar: :any_skip_relocation, catalina:       "06b36336da1fed9b2fdf154fea596d415dc5bd071400623c75da2364027c50e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "645297ffff0fbb67fd8f9b697e076e6c69ff8b7aa903069d7deaee7688454229"
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
