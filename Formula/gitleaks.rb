class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v8.0.2.tar.gz"
  sha256 "db80329125656dc1c5f733a298c6c8132b81c678662ce89337782e5bb6b57457"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abbb3c54fea6ccf665eb54d9032a4875a84b420003dfbdc3a3a7aa9b4f9f259c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "416932f0ea824e66678a7c22a1f42ca97a4468fa919addb0250eb1c309ad389d"
    sha256 cellar: :any_skip_relocation, monterey:       "74e26015534d10c9b70824c00918ca273d3f3b0419db6f1a2b2b96784f38783b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec3c7229662079891098cb82e3c7393166235d728569220b8d6c4af29ef42b25"
    sha256 cellar: :any_skip_relocation, catalina:       "670717e2ca53fe9851a52ae4f61b0a828e41502abd353f20535531d7b137d1a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c31330ad2082d73989ae410bd15ec6377372f5ccf5d57d38567e1c4986f18804"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/zricethezav/gitleaks/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
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
