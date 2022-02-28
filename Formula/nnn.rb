class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.4.tar.gz"
  sha256 "e04a3f0f0c2af1e18cb6f005d18267c7703644274d21bb93f03b30e4fd3d1653"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "46936fa05d86e72d3158d93cf02c0d772bfd4d45e06d24bde11c5e080616a24e"
    sha256 cellar: :any,                 arm64_big_sur:  "d0a8a0b5f7b60ca273252c00cd96264ced4584eb6eda2aae324dcdabd1b27be3"
    sha256 cellar: :any,                 monterey:       "e46cc422287b93fd2df8c945b7f3ce0326c35288a27b58a19ec46e3ac006dc8b"
    sha256 cellar: :any,                 big_sur:        "5f770a11e583185e71e9b50cb3add22ed5aa8cc7f8c7ce955ec2f268b4259113"
    sha256 cellar: :any,                 catalina:       "6ee6bf5437b1f66db97be592e0eb7f93c05da57d3cd60851a79cbd6a635d04d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d17b3364d323f9b50696087ba610c79fc36dd407d5d8a7a461eb5198f538e25e"
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
