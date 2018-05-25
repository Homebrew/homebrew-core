class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20180512.tar.gz"
  sha256 "ac3cd262065fcc20c1dec7c95f06306c8138b3e17025b949343a06a8980a5508"

  bottle do
    sha256 "7105a2f177ab646b43f2aeadece3d8149ad3d3f6c1156e8cf51918b69215dcf3" => :high_sierra
    sha256 "8ea110cd1bb550e9700035b71f0329a4b8c5ae64a2587a03fd22104b94004d9a" => :sierra
    sha256 "fbbd5ba6224b518320cdc92d222ce172a4773a722ca761592c47d40e289b0ed4" => :el_capitan
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
