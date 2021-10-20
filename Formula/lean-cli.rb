class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.27.0.tar.gz"
  sha256 "8d9219abf27ec909577f9736456478242d99d5e2ac0d621fab7c7bc85cce9dd1"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5bacc2bf6ba21ea6a79f63f80448fe35f4d2a919607dd8d0f191c75f7c0e0408"
    sha256 cellar: :any_skip_relocation, big_sur:       "db63d361bede85efe0285ab80f41c20a860c4377bf7c3e175c027775a3a7db1d"
    sha256 cellar: :any_skip_relocation, catalina:      "311eb64400cd1f98edc8dc4589868fdb521b183d70017579e1cb7e053989bde9"
    sha256 cellar: :any_skip_relocation, mojave:        "86f52bf4114a9070f2deeeb3269e33b0a83f22109771948cb069544620a45d78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1481596ba725ca6c93819fd9811db036d44569d9a8621eff59925b1f2139e1"
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build",
            "-ldflags", "-s -w -X main.pkgType=#{build_from}",
            *std_go_args,
            "-o", bin/"lean",
            "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please log in first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
