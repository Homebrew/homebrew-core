class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230120.tar.gz"
  sha256 "4ff625a10471bf15ee512146462e052d7cb380c31ab28b1623d35b6b0160534a"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d02d846461c664d378b6fc5626b8cab592b46aa09303e1c4fe34227313e96548"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac9d711d32c9227088e4a620a75494fbdf0cab2d7f76c44965792a370619e5e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "596c1ae20ea8695caac3ccb289063fd17ef3e7ffb7e25082a473dd25090abe55"
    sha256                               ventura:        "1dd7f910b82553562e7fdc90cbf40b13a34e24cc0f49a01bd5d7a916c42b75e7"
    sha256                               monterey:       "51aa10f29bc2bd6c21c251a34aab7b065a9d8c960f6794ce551aabc4f275baf2"
    sha256                               big_sur:        "2bcf2aef6c89543cfb7561cd7048e0da2812c1c8e59bcb8dd1b20e1935cf23f6"
    sha256                               x86_64_linux:   "b4f37fc544c7b340c571178bf371f104e981282e8a3e2a499b2743acf9c6c9a4"
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
