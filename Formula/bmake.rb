class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "http://www.crufty.net/help/sjg/bmake.html"
  url "http://www.crufty.net/ftp/pub/sjg/bmake-20170812.tar.gz"
  sha256 "cdd9ea1aa5b84b7b892ddf2dccb1c21028de6ce0edf5684432e1f4bf861179c6"

  bottle do
    sha256 "b140c0563d6dc5b1315883684449f99354f86cb6dfb0907ca8e71ced75cf8c8f" => :sierra
    sha256 "5a23861d3812765390abf05be7ccf367886e66495e6070a3f88b164b7522b90f" => :el_capitan
    sha256 "cb084669c4e47b33945e49f373f019ccaf69929b6c57c509c75a37d445dbc7b5" => :yosemite
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
    (testpath/"Makefile").write <<-EOS.undent
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
