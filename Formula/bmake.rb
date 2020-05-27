class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200524.tar.gz"
  sha256 "79e72bbab47dad2cfc8e6041a61287fb852109c8e3dc1defc5a2b64e3966dadb"

  bottle do
    sha256 "3cc65875a38a14e0b6a817b84ea4622af4f249420d2cfbb91883351be55f17ec" => :catalina
    sha256 "ebcf946c695bcf91b6a5ded7b0e6632e9bba87b2ef13405ac49b33a28d46e21a" => :mojave
    sha256 "2171a96acc19eafb4ab821e15306602b8b02edbffe63416d75a4104a7194a92d" => :high_sierra
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
