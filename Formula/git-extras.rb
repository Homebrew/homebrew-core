class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/6.2.0.tar.gz"
  sha256 "151bc129f717179c1f7b6c83faf1d4829eeddef8b7c501dac05dc38c28270c3e"
  license "MIT"
  head "https://github.com/tj/git-extras.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ea543c26cfa1e6c3c76a1f3f83090dbdbcebbea42a163909f3b6f5e9d4d3d8bd"
    sha256 cellar: :any_skip_relocation, big_sur:       "9c71ac1ab00be885a134f3cc634e89a412f61ba79f0c2da89fab10d1b16710e4"
    sha256 cellar: :any_skip_relocation, catalina:      "937098a922e8b3149329d93079d35cd8bfa551296c3798d9a84bccf275d05770"
    sha256 cellar: :any_skip_relocation, mojave:        "55b4518da5dc0d3f07725c86d64a844b8a98cbcdb28f2a8bd99791c444d1838f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa97d3e160b30e65bd02a138aa64737e2849a04b8e1977ac76ef0dd5f2e96b60"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  conflicts_with "git-utils",
    because: "both install a `git-pull-request` script"

  def install
    system "make", "PREFIX=#{prefix}", "INSTALL_VIA=brew", "install"
    pkgshare.install "etc/git-extras-completion.zsh"
  end

  def caveats
    <<~EOS
      To load Zsh completions, add the following to your .zshrc:
        source #{opt_pkgshare}/git-extras-completion.zsh
    EOS
  end

  test do
    system "git", "init"
    assert_match(/#{testpath}/, shell_output("#{bin}/git-root"))
  end
end
