class Pdf2image < Formula
  desc "Convert PDFs to images"
  homepage "https://code.google.com/p/pdf2image/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/pdf2image/pdf2image-0.53-source.tar.gz"
  sha256 "e8672c3bdba118c83033c655d90311db003557869c92903e5012cdb368a68982"

  bottle do
    sha256 "7a62006adfc88fc38c5333d94836127d4f51228291dfddc726f10a1cac1b6383" => :catalina
    sha256 "722d8eefc7f7f12555f4997ca13470fda8b508a2683bc9edc6bfa5b883707202" => :mojave
    sha256 "59ba0fc004f64cafaeb8e9beb6c07964b8df8fb10bf653aeb83713e3610ac182" => :high_sierra
    sha256 "46df7ae58a1bfc73cd1a1c1075de032724514d29995e965169d69f51409cad7e" => :sierra
    sha256 "c12d781ab5136a717cb88cadb50b2dfcd1f67cf263b5b668b1e171f562bcb072" => :el_capitan
    sha256 "a0bb792123e4754d5cf80cf248e8932dd1885616af2c4c9c7f00e35cda962725" => :yosemite
  end

  depends_on "freetype"
  depends_on "ghostscript"
  depends_on :x11

  conflicts_with "poppler", "xpdf",
    :because => "pdf2image, poppler, and xpdf install conflicting executables"

  def install
    system "./configure", "--prefix=#{prefix}"

    # Fix manpage install location. See:
    # https://github.com/flexpaper/pdf2json/issues/2
    inreplace "Makefile", "/man/", "/share/man/"

    # Fix incorrect variable name in Makefile
    inreplace "src/Makefile", "$(srcdir)", "$(SRCDIR)"

    # Add X11 libs manually; the Makefiles don't use LDFLAGS properly
    inreplace ["src/Makefile", "xpdf/Makefile"],
      "LDFLAGS =", "LDFLAGS=-L#{MacOS::X11.lib}"

    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/pdf2image", "--version"
  end
end
