class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20200506.tar.gz"
  sha256 "0ac33c9bb00f12e54a3571e492f8c88cd835f6df64533d008e188a47373538e2"

  bottle do
    sha256 "0599641d6924bc5a64abf158499d1511574aeb09c5d39d3532253a7b2bb579e2" => :catalina
    sha256 "65baa9165f9862aac329267b35caa96ea1b9b47f3640ca7d06a4cda11951f14b" => :mojave
    sha256 "530be04f7550162240b73fe0b0baeabcddc8d4afb46b71123c2bef16a872dd74" => :high_sierra
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
