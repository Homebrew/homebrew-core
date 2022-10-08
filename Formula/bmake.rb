class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20220928.tar.gz"
  sha256 "c804b77de3feb8e31dee2a4c9fb1e9ec24c5a34764e7a2815c88b4ed01650e90"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "917eef02d3e21c945397cd4c54e15f3349c45685b89da7d03ab51b49d6af330a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "365d3597d96298680ab25d359b903de39e8f0bb344897a7e764e376e69484544"
    sha256                               monterey:       "8f91c57a84e46e3ef181f8229319bd2bb4a919c1cec226ca21def7f601641933"
    sha256                               big_sur:        "adef066d7d3b5f5576a0034b22bd93120673bcb6d13739876a445763e279e6aa"
    sha256                               catalina:       "2de17ff4fcd09935b26cb9aebbf830173ac0a7e327925fbf6d938f92e0024f83"
    sha256                               x86_64_linux:   "ea8c84a07426894f9a66b83c4b795535215518ddabab3528ccbae085e7074363"
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
