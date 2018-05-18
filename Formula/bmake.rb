class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20180512.tar.gz"
  sha256 "ac3cd262065fcc20c1dec7c95f06306c8138b3e17025b949343a06a8980a5508"

  bottle do
    sha256 "60524815967d5108415212b78e030bcc22ad3ed3845d092a3417fcf87b5f48c5" => :high_sierra
    sha256 "950b008466582b51eddc5c551234ff6c617e112ad1297fd8da070ab442af5b32" => :sierra
    sha256 "01563962361d5886c821feae150b4d2a699d9fb2ba72bd734d1d9d992611d11f" => :el_capitan
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
