class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.18.0.tar.gz"
  sha256 "dedbfd01223d162c62fb1f271cd25cf48869ea40adcc12b90fc2939d55b27612"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01e58a2eacbe5aac49180dc371665f0310d742fd20a6f7bf6ca59dd0ffd39cd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15961f42d5d76fde1f709b87aff180d515cbbbe23087cb655f02dd79aa72e63c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "189c1a785d09fddb2850d2b691b0b09d0b44e6d26ad50415ec053336f10b47e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cbdbe734257c5f8c1b5a5aa8d195ab48a596b69aeac072a40a78e48e8884a63e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e2c1529d52eae0f4e3b89373a9d95ebbd078e28603e4059f7e1c0e0f8b4e55a0"
    sha256 cellar: :any_skip_relocation, ventura:        "b3004841e376ce9f767175d62669536aca22aea68334386d683f00f4956b3ce3"
    sha256 cellar: :any_skip_relocation, monterey:       "bba7ecb9f27bf75c06a2cba67602ee4ce8738bae3215e92876cc51cfc77412d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ae0db8a3875d8e9748592fe57a89d6affeb8021e51e80b555f86d622c310e8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de53975f2431267591002b2bff56370e51ce124956111923a2e6ee8953c7445f"
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
