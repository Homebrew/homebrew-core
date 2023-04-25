class GitExtras < Formula
  desc "Small git utilities"
  homepage "https://github.com/tj/git-extras"
  url "https://github.com/tj/git-extras/archive/7.0.0.tar.gz"
  sha256 "3adcbc247d6cb78dc58cace22e9ad789cd6f5061522516660dfb59cc6ec08def"
  license "MIT"
  head "https://github.com/tj/git-extras.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59d95f1583bfadaf3d3088fda40871c703668e8acc9592f544e49de5341956ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59d95f1583bfadaf3d3088fda40871c703668e8acc9592f544e49de5341956ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59d95f1583bfadaf3d3088fda40871c703668e8acc9592f544e49de5341956ec"
    sha256 cellar: :any_skip_relocation, ventura:        "59d95f1583bfadaf3d3088fda40871c703668e8acc9592f544e49de5341956ec"
    sha256 cellar: :any_skip_relocation, monterey:       "59d95f1583bfadaf3d3088fda40871c703668e8acc9592f544e49de5341956ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "59d95f1583bfadaf3d3088fda40871c703668e8acc9592f544e49de5341956ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57de92d7366e7b2f23d2d767bf43bb82c7710a745074eaf7a166a40ac091ea68"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  conflicts_with "git-sync",
    because: "both install a `git-sync` binary"

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
