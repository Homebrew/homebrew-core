class Forgit < Formula
  desc "Interactive git commands in the terminal"
  homepage "https://github.com/wfxr/forgit"
  url "https://github.com/wfxr/forgit/releases/download/26.01.0/forgit-26.01.0.tar.gz"
  sha256 "df16e3ca5da44724d2712f26e6df3190c43fa35e0f6d0e48da055fa426f9aa36"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "804c7bad5b4812cac2550314388e63f3b22a58c4dce340ab9220c81edaa7fcd4"
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
