class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20180919.tar.gz"
  sha256 "b0dd038583fe4a627f52f109887b71d365d8c51ec87f0e3fcb3ab6a9124eccee"

  bottle do
    sha256 "133b0f024e8722fc8329cb36017fad0bc78b10b6eacc30d4d7ae72f8cab0c7ee" => :mojave
    sha256 "600a948d86983ed62fa409dcb4b7db0d6323866e79acf1cfced9b81973ed4859" => :high_sierra
    sha256 "72b83c275872c5f86ae56272fd6477fff883bc29f79de80ef11592bc4aa84243" => :sierra
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install"]
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
