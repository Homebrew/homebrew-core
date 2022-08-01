class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20220726.tar.gz"
  sha256 "1bf3770789722721dca7b0bff8afc4a9520da20f0219bb7bc52350af0133f0a0"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d181aae3f6b164be976b5b5e0eccb5eea1c57fbe1a872d59ce3598f1e7b5484"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83553703f2a7ce5a4df1e2899a3fd7a4f40d3c9d3955f117faf2561fa86ffb6d"
    sha256                               monterey:       "2ab38f78292d6876e8251a9dcad150687e10129593c42810a13bb83765e5cdb0"
    sha256                               big_sur:        "7992cac22e539eb2f2ec71f9fb167cea1c27df3b5a07c2c4bba85c0f94027cd0"
    sha256                               catalina:       "e6bd9a637f0a8703d5e7fc65911768b8a0e9681b06fda7f7d0c40ec9738784c4"
    sha256                               x86_64_linux:   "7ec0fd8c6cc477e69fbfde079c15c53c36c7417d60044269812fefc68ccd818d"
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
