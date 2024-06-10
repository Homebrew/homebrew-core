class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https://github.com/wfxr/forgit"
  url "https://github.com/wfxr/forgit/releases/download/24.06.0/forgit-24.06.0.tar.gz"
  sha256 "7beb5e5938000b966c1c2b5d17786ae53aa85fc9127e8eb5ee41aa0210b0955b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3302e0bdfc0cad63e04a3ec12cc5bc797bc92de5634dcd101c67e009d2271e60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3302e0bdfc0cad63e04a3ec12cc5bc797bc92de5634dcd101c67e009d2271e60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3302e0bdfc0cad63e04a3ec12cc5bc797bc92de5634dcd101c67e009d2271e60"
    sha256 cellar: :any_skip_relocation, sonoma:         "3302e0bdfc0cad63e04a3ec12cc5bc797bc92de5634dcd101c67e009d2271e60"
    sha256 cellar: :any_skip_relocation, ventura:        "3302e0bdfc0cad63e04a3ec12cc5bc797bc92de5634dcd101c67e009d2271e60"
    sha256 cellar: :any_skip_relocation, monterey:       "3302e0bdfc0cad63e04a3ec12cc5bc797bc92de5634dcd101c67e009d2271e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64eb5a0d561a1af5a9733dc330239d805794d0fc4035eedcc51b6e1d83e7c4c6"
  end

  depends_on "fzf"

  def install
    bin.install "bin/git-forgit"
    bash_completion.install "completions/git-forgit.bash" => "git-forgit"
    zsh_completion.install "completions/_git-forgit" => "_git-forgit"
    fish_completion.install "completions/git-forgit.fish"
    inreplace "forgit.plugin.zsh", 'FORGIT="$FORGIT_INSTALL_DIR', "FORGIT=\"#{opt_prefix}"
    inreplace "conf.d/forgit.plugin.fish",
              'set -x FORGIT "$FORGIT_INSTALL_DIR/bin/git-forgit"',
              "set -x FORGIT \"#{opt_prefix}/bin/git-forgit\""
    pkgshare.install "conf.d/forgit.plugin.fish"
    pkgshare.install "forgit.plugin.zsh"
    pkgshare.install_symlink "forgit.plugin.zsh" => "forgit.plugin.sh"
  end

  def caveats
    <<~EOS
      A shell plugin has been installed to:
        #{opt_pkgshare}/forgit.plugin.zsh
        #{opt_pkgshare}/forgit.plugin.sh
        #{opt_pkgshare}/forgit.plugin.fish
    EOS
  end

  test do
    system "git", "init"
    (testpath/"foo").write "bar"
    system "git", "forgit", "add", "foo"
  end
end
