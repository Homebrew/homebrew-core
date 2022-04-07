class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.6.1.tar.gz"
  sha256 "40aa9440bb8dc369f10a3e87614cf0cd1c7722ce6d8bc12b814d7793ba0766ad"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f63c7153ede4cf851ed2682155387bafa04101f4f32ea411e0042ec8a263d8c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4f69af338d26e5f7d605085179b0066f0290bb0f9f09f252ba0fc4a2a0274a3"
    sha256 cellar: :any_skip_relocation, monterey:       "1b6dba8fdfa26cb3cc6adfe4c39d31b9fcb328e56d1c6bf6ba86b97ab3d23370"
    sha256 cellar: :any_skip_relocation, big_sur:        "11c17a6240db7c13682d4f22f494103b2875a083a2a1d5ec5181af04ebb17dce"
    sha256 cellar: :any_skip_relocation, catalina:       "25cc5cfd3d03647a186195ef1e9201d66c4a6c210c60891555b90c3778d31dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff181a96e93f1b520be550297577890975c7d0f08d0f8d51709a0594743a253"
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
