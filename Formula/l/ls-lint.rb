class LsLint < Formula
  desc "Extremely fast file and directory name linter"
  homepage "https://ls-lint.org/"
  url "https://github.com/loeffel-io/ls-lint/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "018d9291f96e10386ee68ce7e12b830750c98b6939fb1d587a808d8509affcce"
  license "MIT"
  head "https://github.com/loeffel-io/ls-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8bc8ac0bb2125206d838b62ef66679bfd294b580223ce95d2c3cfae45c33e206"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8bc8ac0bb2125206d838b62ef66679bfd294b580223ce95d2c3cfae45c33e206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8bc8ac0bb2125206d838b62ef66679bfd294b580223ce95d2c3cfae45c33e206"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cb9f18723f384a33c3643fafc2dd0331ef5afd0c1665e8fdfc1d6c60586a09b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6cd8fb7da4ffda8f4050414ecb5f71a4a914f6d852cd1b14b9776ca75ed31a3b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/ls_lint"
    pkgshare.install ".ls-lint.yml"
  end

  test do
    (testpath/"Library").mkdir
    touch testpath/"Library/test.py"

    output = shell_output("#{bin}/ls-lint -config #{pkgshare}/.ls-lint.yml -workdir #{testpath} 2>&1", 1)
    assert_match "Library failed for `.dir` rules: snakecase", output

    assert_match version.to_s, shell_output("#{bin}/ls-lint -version")
  end
end
