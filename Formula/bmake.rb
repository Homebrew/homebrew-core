class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230303.tar.gz"
  sha256 "e8698724ac68c63f8e6682a93c3154c1d93dc6a9072f13c8cef07ece4ccd0ed6"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bcacd5dfa587c0cba22e61d40b805302066660a0c7b7086dd23fb02ed0d7b36a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e67c8377cb53e66db6374546c6431ec8006b80db4a8cda475b940c419ee9d0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baa4d576e3ebb3cf85ca5e03a15688da8d19a3ec825d558ef5041f3bafaf5f95"
    sha256                               ventura:        "fac9d449e03eb757f4445501969cd73756996e9cfcceb5927d2787f8db9ba810"
    sha256                               monterey:       "4c73a7afe3c7b0cf6635c401bbdf20bf0c5b627607f0a449df8be36da2f5b825"
    sha256                               big_sur:        "2bfa6dd8f333e83d25e6f5e02acb967d6f26d59c1de0ca284e97ed7022a67c9a"
    sha256                               x86_64_linux:   "1db69029e06d20fead59fd34224da0357c8768bffcad3e7ecb3e38506d15b521"
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
