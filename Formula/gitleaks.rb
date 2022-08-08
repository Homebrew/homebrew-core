class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.10.2.tar.gz"
  sha256 "cd7a436e762cbf7437e29342c74f49f2c684e33aededd67e7315bfd15fd77fa1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94ba43643c0f33536579bec3ca5403e15036e6aa3dd5b2a154ec3b8ea42f926f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec00c3cf134e682f4c002296a6346908ee147f40459d3df920dfc6a5924ad886"
    sha256 cellar: :any_skip_relocation, monterey:       "84fc6e75676d38ed312770675005c75ceb0473e0595defe9441b2a13114b518e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfdfdb183f3f412aedb01369bb4f9336018aecd672cf1ca63b0ac2dba03d07ce"
    sha256 cellar: :any_skip_relocation, catalina:       "48aab2f021fb1639366fe785fbf77ee1527a5b2bd6a890be604d0bdafe9af99d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc4df81ebd62a54347f918f5028548edf0a1156e7bd3bae3aefe1f16357e8e57"
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
