class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.5.2.tar.gz"
  sha256 "047db4b20f19fb4e73a79dbb1c669cefec9fb0cccb23e1fad91a9cdfe04d57e4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaa64801f1b672582bf988e91a3187bda96f0632dfb4f0d6cf566c512a4429b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "865cd20c565d98fb00684e45419c5fcf201be90ba4904447fc31a53e988d743a"
    sha256 cellar: :any_skip_relocation, monterey:       "d8df132d162106b0f0ca34de14f8ef06eb8d0bc7a948a5369638c75888d5c761"
    sha256 cellar: :any_skip_relocation, big_sur:        "24cfaf247122fdf2d8cc4c694aab2d9927770f770ae15ffe03ccd14b7a267bb9"
    sha256 cellar: :any_skip_relocation, catalina:       "d0b249ad2f3c11d429823cdc7d59527264e1b2994ca3b43820298f90fb308d7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e738e2653d841f2b66c8ee9f5d913a3fa04a511b1e0777dd1a2676191edf3d79"
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
