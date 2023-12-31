class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/refs/tags/v4.9.tar.gz"
  sha256 "9e25465a856d3ba626d6163046669c0d4010d520f2fb848b0d611e1ec6af1b22"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "a661f24f20729323cc44905e72b5e0615809cd6dc00923355276e8bc327e8d2b"
    sha256 cellar: :any,                 arm64_ventura:  "da99936ce4f9aa649cc5114bf34724dec324e1fe0484258036cd50ccd974d566"
    sha256 cellar: :any,                 arm64_monterey: "ef086ae9e6fdf3ee271b5c64a5b9355b49b311a6f3afc75aab8a452f8c03e155"
    sha256 cellar: :any,                 sonoma:         "29597f38dca184b1e8283f788d9feb0d9d610bb20294d49a666864cacaf51ae8"
    sha256 cellar: :any,                 ventura:        "9c2d3f2668b52cfc5c8cfd9f1970501cc67767ea82e3e033d76e6bc263edfaff"
    sha256 cellar: :any,                 monterey:       "c3e95d1ca7c575edbc4bfae316b58f218598a5926c4f1c6577b19e0f4cbeae92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "866a588102383c2f892e434139af2962ab0d179469681cb4e8f2eacb6f55d3ce"
  end

  depends_on "gnu-sed"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"

    pkgshare.install "misc/quitcd"
  end

  test do
    # Test fails on CI: Input/output error @ io_fread - /dev/pts/0
    # Fixing it involves pty/ruby voodoo, which is not worth spending time on
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Testing this curses app requires a pty
    require "pty"

    (testpath/"testdir").mkdir
    PTY.spawn(bin/"nnn", testpath/"testdir") do |r, w, _pid|
      w.write "q"
      assert_match "~/testdir", r.read
    end
  end
end
