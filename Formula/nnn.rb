class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v4.5.tar.gz"
  sha256 "fadc15bd6d4400c06e5ccc47845b42e60774f368570e475bd882767ee18749aa"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "050519b7b5d2227fd0fe1774c8769a4c0440fd74b6b32093c46399d639a6d8cd"
    sha256 cellar: :any,                 arm64_big_sur:  "2cea5e82e5f9269c55eb1bf0e72d8a96241e5807a157fbb48a995c9090b580d8"
    sha256 cellar: :any,                 monterey:       "789d680be159aa6ea077d4c11a2a5eb255eaf8073e77b3fb609e9647abe313e3"
    sha256 cellar: :any,                 big_sur:        "2e7e159ae741f0c851a8be6d33c5bd4dba26ec88a1685e7f8b43ced711cfe4dc"
    sha256 cellar: :any,                 catalina:       "1b19cd02da90939a63955cda3de89dcd6575fede984a3494720ba7bb082be503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d132f9a3c7fff3470cadbe04b403c4d484d1ea3957274756904b646b7c7f6d7d"
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
