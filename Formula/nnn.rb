class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.0.tar.gz"
  sha256 "a219ec8fad3dd0512aadae5840176f3265188c4c22da3b17b133bac602b40754"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3121884b9703f5bc511499904d0cd65c941ce22cb80eeb0a0c650e75de0788e3"
    sha256 cellar: :any, big_sur:       "e6ab60e20d2ec6e9ce86c7774843141e19ac3f71fdb1022b9e8a9206ee2a8f3a"
    sha256 cellar: :any, catalina:      "abd54ea24cb7ed46303b925f22466592c0ceaffbe8b8a8ec67ac6421c05bf64a"
    sha256 cellar: :any, mojave:        "16a859bc4fafbf733092be7c8b03a738f165b358f87b1738dee7b349e2e1c47a"
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
