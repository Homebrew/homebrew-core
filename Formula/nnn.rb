class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.2.tar.gz"
  sha256 "5675f9fe53bddfd92681ef88bf6c0fab3ad897f9e74dd6cdff32fe1fa62c687f"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "d9a3862cf7914262ba82dc0fa1b1480892525f68c08e89239a7ba00dfc4a7027"
    sha256 cellar: :any,                 big_sur:       "0ef88ba75921141f4eacb37757adb7770f43b6023f33a93ac66c7c52aaade089"
    sha256 cellar: :any,                 catalina:      "781e185190d63497a7eb6a02b1de8010127b9094c579f852375acb94e9d43894"
    sha256 cellar: :any,                 mojave:        "0eb70281533062f08f3b3bc2a003b4ee85d87999afb40cd3822304f22bbc582c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5e366fe22e2c5be474220916651ac122d779c0b97336952ec0dd43025ac687"
  end

  depends_on "gnu-sed"
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"
  end

  test do
    on_linux do
      # Test fails on CI: Input/output error @ io_fread - /dev/pts/0
      # Fixing it involves pty/ruby voodoo, which is not worth spending time on
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    # Testing this curses app requires a pty
    require "pty"

    (testpath/"testdir").mkdir
    cd testpath/"testdir" do
      PTY.spawn(bin/"nnn") do |r, w, _pid|
        w.write "q"
        assert_match "~/testdir", r.read
      end
    end
  end
end
