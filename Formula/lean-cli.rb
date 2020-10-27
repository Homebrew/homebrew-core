class LeanCli < Formula
  desc "Command-line tool to develop and manage LeanCloud apps"
  homepage "https://github.com/leancloud/lean-cli"
  url "https://github.com/leancloud/lean-cli/archive/v0.24.0.tar.gz"
  sha256 "588e1b3e52bc69087211bb68301f9958b008d97e532c0831a76ab734ddab5c81"
  license "Apache-2.0"
  head "https://github.com/leancloud/lean-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e82598e5c3b9745916643d9cd2583b4b0ce20a959b4e2e8771b005f08ea9771" => :catalina
    sha256 "b4276d4e5b173681792e843c7bab6549f9c8e67bf02f9e4fae3a2763382375c6" => :mojave
    sha256 "694ddcb9edd1bfe40673afbe0c01b1bb67d0c41ac3561ceb1855b47c56eea31a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    build_from = build.head? ? "homebrew-head" : "homebrew"
    system "go", "build",
            "-ldflags", "-X main.pkgType=#{build_from}",
            *std_go_args,
            "-o", bin/"lean",
            "./lean"

    bash_completion.install "misc/lean-bash-completion" => "lean"
    zsh_completion.install "misc/lean-zsh-completion" => "_lean"
  end

  test do
    assert_match "lean version #{version}", shell_output("#{bin}/lean --version")
    assert_match "Please login first.", shell_output("#{bin}/lean init 2>&1", 1)
  end
end
