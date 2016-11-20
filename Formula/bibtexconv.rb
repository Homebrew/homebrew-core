class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.7.tar.gz"
  sha256 "acba9c87d9f301dd128dcb480b7a031324579708263c297f5994cb3590b710b1"

  bottle do
    cellar :any
    sha256 "8bbc5bfd4e021dada1361ed4f8e92e7e7dec92350190ce3baed8adeb4381f116" => :sierra
    sha256 "fdfa0ac4890ef0627c5901c3c287920217fc5fad203f67f7be2c1107b4b846e5" => :el_capitan
    sha256 "f9a8d3a46ebd1261dbef3b12bb0447788791275a4ccc94e35ff35d9d60c00555" => :yosemite
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
    ENV.j1 # serialize folder creation
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
