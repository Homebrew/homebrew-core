class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20211221.tar.gz"
  sha256 "c48476c1c52493e61a5342d7d8541608f7852244f3c74ffd7676b6537c475bfb"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7df86a291fa5062343209362c50d17dece6d975c258ab14137a6e6104d31cf3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "140f154bb01414bfe1d7bc5435423110de32250ba4795043cc906da21121a51c"
    sha256                               monterey:       "632e62e81c5ce16ae090aa545f6aa42daf311af8070e3f51661e396734170d63"
    sha256                               big_sur:        "1ea7f0910a5607ae698f97f45354ec3bac3b893322d9617cc65fbe236fff002b"
    sha256                               catalina:       "934eac00db0a8a326edb5cd8869f6421bdd7750c2870acc50550dc22b49be293"
    sha256                               x86_64_linux:   "acd49c53dcc682a325df43bfd663ed3c51c52c138c388689445e70dbdf9e0e39"
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
