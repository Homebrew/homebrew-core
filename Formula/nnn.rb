class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.3.tar.gz"
  sha256 "b6df8e262e5613dd192bac610a6da711306627d56573f1a770a173ef078953bb"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "012dfd0469540bf5683cad24b8a5146d6966faf95e965be5400e61dd9de03a6a"
    sha256 cellar: :any,                 arm64_big_sur:  "6d072778621d10a72e476f50c8a24f376d2959dae78e186bb3c11d69f1a7a7f7"
    sha256 cellar: :any,                 monterey:       "7e598373bd481a32a6ef6869cba7cb27568cd448a5689a49e062f0776cbb9907"
    sha256 cellar: :any,                 big_sur:        "9f99a0bd00d1f224d7a357941e419fadbf6385f6316505108e7592a1b76403fc"
    sha256 cellar: :any,                 catalina:       "63cd86d85ab2464ca084fe671784cf8228b65b6fb6026375845940e8d1827f77"
    sha256 cellar: :any,                 mojave:         "f1aa16087e160457a96cf549135b0f9c4fe875a6a888064fa8bd92cda5c1b6f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b431bf5a86d696c6784e9faa375c249d5456bbf5c101606e949a840ed7b6471"
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
    PTY.spawn(bin/"nnn", testpath/"testdir") do |r, w, _pid|
      w.write "q"
      assert_match "~/testdir", r.read
    end
  end
end
