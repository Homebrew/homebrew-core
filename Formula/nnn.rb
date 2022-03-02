class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.4.tar.gz"
  sha256 "e04a3f0f0c2af1e18cb6f005d18267c7703644274d21bb93f03b30e4fd3d1653"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "a501ea4672132cc244350da950fdc9d9d0055817d3750d9e6af9606963352bff"
    sha256 cellar: :any,                 arm64_big_sur:  "5f38441300ef7ba4362347c31ae066d3ece1a7fa9cc2a2c338320c7ad08616f3"
    sha256 cellar: :any,                 monterey:       "c6acc69cb0a17a6590ffd120cde8689c4ffc49e82f90ae118c9cc88307757b36"
    sha256 cellar: :any,                 big_sur:        "f2f9e619242ec374a8c6767d4536481e44e0a33a36950216b1b3171d76761ba3"
    sha256 cellar: :any,                 catalina:       "b63330777fa093c55c4fed5821dbfdd9c60b903aaaec08db304476aa2349184b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7b6322643a865339bf3c6b4d0a4adf57e291fa0333115bce1ee99243fd8f76b"
  end

  depends_on "gnu-sed"
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"

    pkgshare.install "misc/quitcd"
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
    PTY.spawn(bin/"nnn", testpath/"testdir") do |r, w, _pid|
      w.write "q"
      assert_match "~/testdir", r.read
    end
  end
end
