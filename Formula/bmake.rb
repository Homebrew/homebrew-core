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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c3e44dae218683a2df899eb0afe512fb042c10b1567d98cf98e45c577e7a8cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d23d681d380d0c15038a0b41f8a37d9078ee7f70e4d9e301edc55e6135de6057"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73b9bf06a0e7ca350e894bb4898339a84f9c33132b0fa43cc5cc5ef524f3eda1"
    sha256                               ventura:        "a8463a44b9479d5c1e869a5efc3ef325f988cc364a3081bc0b113a48f282ab09"
    sha256                               monterey:       "2384c459bba4a383e83f673eb5904bc10cb201f0fa926dd04c6b23f79d121bc6"
    sha256                               big_sur:        "6fac81b4196ad2d3469910ccd36903932ac98c83bf847eff96a3ad6155d37b84"
    sha256                               x86_64_linux:   "d7e8d792786a7c6733e9ed4d89381f4f5e9b63c3bd1719bd108cb0c379cc9376"
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
