class CondaZshCompletion < Formula
  desc "Zsh completion for conda"
  homepage "https://github.com/conda-incubator/conda-zsh-completion"
  url "https://github.com/conda-incubator/conda-zsh-completion/archive/refs/tags/v0.10.tar.gz"
  sha256 "b80cc42581d8764a3a33b996aeb1326bc1a5b6451ff834f30253bb723378c23c"
  license "WTFPL"
  head "https://github.com/conda-incubator/conda-zsh-completion.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "09386462510b271816be1c39b74815580f63fc15c01a3889100d9ff7ea29aefb"
  end

  uses_from_macos "zsh" => :test

  def install
    zsh_completion.install "_conda"
  end

  test do
    assert_match(/^_conda \(\) \{/,
      shell_output("zsh -c 'fpath=(#{zsh_completion} $fpath); autoload _conda; which _conda'"))
  end
end
