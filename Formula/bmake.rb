class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20220724.tar.gz"
  sha256 "aefabbc723fb20a583b39f6518256dd8deb23108322c25bc38284175888b257a"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf0f133f588f36936d923fb647cd92e9a4a1ecb07868b3ecebe32df7377930ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33099f5ee54c088e6e534cf79b5ed6ce61f53ebb28f3f749ae5b6470abdc88bc"
    sha256                               monterey:       "1152dc2e7c757d05890bce2f5d67cae877d6179eb228a969c6b1ab4e2f484a47"
    sha256                               big_sur:        "ed16394880239ec8b6fd0214e02c5665ce05344e68b20474f28a098e1678b147"
    sha256                               catalina:       "1b611932389043df5ac25f509a6503ebd5fddc879dbe59fce1ccf82f181c1664"
    sha256                               x86_64_linux:   "7638ab6295ff1231bcb2072198f69aa24d944528b6186253112452dd0d00fc48"
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
