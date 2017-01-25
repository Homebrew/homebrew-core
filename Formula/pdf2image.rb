class Pdf2image < Formula
  desc "Convert PDFs to images"
  homepage "https://code.google.com/p/pdf2image/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/pdf2image/pdf2image-0.53-source.tar.gz"
  sha256 "e8672c3bdba118c83033c655d90311db003557869c92903e5012cdb368a68982"

  depends_on :x11
  depends_on "freetype"
  depends_on "ghostscript"

  conflicts_with "poppler", "xpdf",
    :because => "pdf2image, poppler, and xpdf install conflicting executables"

  def install
    system "./configure", "--prefix=#{prefix}"

    # Fix manpage install location. See:
    # http://code.google.com/p/pdf2json/issues/detail?id=2
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
