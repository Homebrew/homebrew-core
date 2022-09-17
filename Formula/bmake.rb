class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20220909.tar.gz"
  sha256 "34e9704a93fc183e3f1d87a81f9eabeba3200052f57fed4a751a5968d6b70225"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b980a2ef06470663a63383d93a12802dfb9af9f4661d25ffa2aa3a31633e9b86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "972eeef3e23be540a8914fcad3479baa932f41621fdf1f9fe6db8a49f2b64794"
    sha256                               monterey:       "838df0b198cf99be70cecd65413e3acce2f3426bd1b9c551cb8b24783cb5f12d"
    sha256                               big_sur:        "6f142cbfc4de033ba0867676e4dd177ef3001d077f5dda26ea7bd0f09c3107a3"
    sha256                               catalina:       "40c504f54a2127860dd54ae8a96eea8fd8c05c1e7904447b938a664d5fe3a250"
    sha256                               x86_64_linux:   "0b0e9673cf20a44d05e9057c514b0973d0a4b9398cc1d0df9bf3b48d31be00ab"
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
