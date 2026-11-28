class FzfTab < Formula
  desc "Replace zsh completion selection menu with fzf"
  homepage "https://github.com/Aloxaf/fzf-tab"
  url "https://github.com/Aloxaf/fzf-tab/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "d75ac08c2c8af5a6a0478787b0f11fabbe24951973b7841ae963431e2070ee9a"
  license "MIT"

  bottle do
    manifest_sha256 "9231851ff2119273b70ef96637a8b2ced7607ad41636124d27013d4a44fe0d9c"
    sha256 cellar: :any_skip_relocation, all: "070b819cece9212109f22a5f0c8dc93aedf3e2e5d58378a8d4f945a81a0f99b0"
  end

  uses_from_macos "zsh"

  def install
    pkgshare.install "fzf-tab.zsh", "lib", "modules"
  end

  def caveats
    <<~EOS
      To activate fzf-tab, add the following to your .zshrc:
        source "#{opt_pkgshare}/fzf-tab.zsh"
    EOS
  end

  test do
    assert_path_exists pkgshare/"fzf-tab.zsh"
    system "zsh", "-c", "source #{pkgshare}/fzf-tab.zsh && (( $+functions[fzf-tab-complete] ))"
  end
end
