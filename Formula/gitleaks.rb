class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.8.2.tar.gz"
  sha256 "de027c9eb14af60ed93fb38e52d89b9f14bd929627890d83baafea615ab60820"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "509066bcfb7c6d2fc6bcf60a03b379d3d32e50ff3930f0e76f8c5366c5a6513b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1137c1ba93632264c09a95093a7a1681fd8fb0055655a1944bc8cf214d91cfa7"
    sha256 cellar: :any_skip_relocation, monterey:       "ef845bff74fa75f81489155f58a1b63299fbd79ada3e7c4108f3d889e256af99"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb04e8d8630c59be70792ea5c05689c40bba8cc421542d8c3fff919c9c3775fa"
    sha256 cellar: :any_skip_relocation, catalina:       "8e8c84cd7ac984b95b3a21b5e7b07804af6b7e2e393346f1a36f2717e6b56fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adb98b13baa53fadeb5780bf18fb0ed16b630ca83be4b5123104b3509ddf7dfa"
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
