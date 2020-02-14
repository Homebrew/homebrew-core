class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200212.tar.gz"
  sha256 "62c1aacbb70ad4df8d67e371bd0d9585d0843486eb33f1e2d047e632e95d918c"

  bottle do
    sha256 "a91c1b0f6a328d4807540d47696d5fc7723d101209464b1c642e51ea10bff19b" => :catalina
    sha256 "982395afa33bc45fd0ae39c68c9474c5f55a4a720fb6fb4480d0c2a13e31bc30" => :mojave
    sha256 "80827f6b3c39f696667c44a6bb44c7b31ffed5e0483249f5a5221aa3096ad489" => :high_sierra
    sha256 "439d4fe0a306fd861ed37f6a80a7ba05c463778be449e4cafd12dddbc073103d" => :sierra
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
