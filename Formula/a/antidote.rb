class Antidote < Formula
  desc "Plugin manager for zsh, inspired by antigen and antibody"
  homepage "https://getantidote.github.io/"
  url "https://github.com/mattmc3/antidote/archive/refs/tags/v1.9.7.tar.gz"
  sha256 "67245a39d9719251e295cbeae7b050c99eccff5b978badd1e4b61e90575a6fac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0800c00d9ecd35ecaa23c8e27453e71d30003b8ed005e5ff03b923205b67fd58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0800c00d9ecd35ecaa23c8e27453e71d30003b8ed005e5ff03b923205b67fd58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0800c00d9ecd35ecaa23c8e27453e71d30003b8ed005e5ff03b923205b67fd58"
    sha256 cellar: :any_skip_relocation, sonoma:         "0800c00d9ecd35ecaa23c8e27453e71d30003b8ed005e5ff03b923205b67fd58"
    sha256 cellar: :any_skip_relocation, ventura:        "0800c00d9ecd35ecaa23c8e27453e71d30003b8ed005e5ff03b923205b67fd58"
    sha256 cellar: :any_skip_relocation, monterey:       "0800c00d9ecd35ecaa23c8e27453e71d30003b8ed005e5ff03b923205b67fd58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d01823dffb00d349adeb9411c77a17c6f72695c3919124486525ebca12aee908"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "antidote.zsh"
    pkgshare.install "functions"
    man.install "man/man1"
  end

  def caveats
    <<~EOS
      To activate antidote, add the following to your ~/.zshrc:
        source #{opt_pkgshare}/antidote.zsh
    EOS
  end

  test do
    (testpath/".zshrc").write <<~EOS
      export GIT_TERMINAL_PROMPT=0
      export ANTIDOTE_HOME=~/.zplugins
      source #{pkgshare}/antidote.zsh
    EOS
    system "zsh", "--login", "-i", "-c", "antidote install rupa/z"
    assert_equal (testpath/".zsh_plugins.txt").read, "rupa/z\n"
    assert_predicate testpath/".zplugins/https-COLON--SLASH--SLASH-github.com-SLASH-rupa-SLASH-z/z.sh", :exist?
  end
end
