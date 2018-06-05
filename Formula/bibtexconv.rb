class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.12.tar.gz"
  sha256 "33d7dd6fcc940f7c4b1a14e1d8a5b9c7c57098d0ae72a6187722dd0ad85e36f2"

  bottle do
    cellar :any
    sha256 "2b44b8dd4bf60b443c9318e056fdcffaed9218e75d7d907dd6ae5c4679a135e9" => :high_sierra
    sha256 "81c4daa41ddb6837d40b66a883aceeb3470ca03148fcc6fd19386ff623776dd8" => :sierra
    sha256 "397edcb9360918833774139e8cf9d11bcb53fc7c763e487a7bec325861b73cd6" => :el_capitan
  end

  head do
    url "https://github.com/dreibh/bibtexconv.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    if build.head?
      inreplace "bootstrap", "/usr/bin/glibtoolize", Formula["libtool"].bin/"glibtoolize"
      system "./bootstrap"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize # serialize folder creation
    system "make", "install"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
