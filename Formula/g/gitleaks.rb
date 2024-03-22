class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/refs/tags/v8.18.2.tar.gz"
  sha256 "07e63c71a927472897846b1c0354ea2d42b7ff38da0a4dc2fb293653b8a77ba8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ad656402c1b5413ceb93eb4b309ef7b7c7b6033377e1b240c9cc38c0a9448e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4559fafbd7ef85e4389110ec4229f56cd654503b115609245930a5181957ff4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0a85d01b3e68cc1638590607b5213ac8c3ef6386a11dcf347aba27938561802"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f4b56ca69e6abd195130c12a40920a342875ceccbc40ec29628de9d8f36a08c"
    sha256 cellar: :any_skip_relocation, ventura:        "477673bfacc427b271392eabd808a60b36da6f638517dc627f03f62b6d17f713"
    sha256 cellar: :any_skip_relocation, monterey:       "bf4e3510522ebddb0c4619811d9448921fed6a7e6bb33a9b121f2e5ad9b67b56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54f52863336583228c0745d77b0ec41a7f4af43884ad0037f0595ef0ac4ff46c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

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
