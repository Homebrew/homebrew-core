class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.9.tar.gz"
  sha256 "405e6f6e09bee7e4ada582e1d05d7b934369d63a2da7fd6baf1edc1701b89625"

  bottle do
    cellar :any
    sha256 "c38c8d20a76071e57f4b678a586b8f7e213a2028d64de595a4911454c97c469f" => :sierra
    sha256 "c8e2fb247bec2234227366eb9c7adac11b0a04c8f2c6ed0bf251947414dadde9" => :el_capitan
    sha256 "a1cba2452e21e2ea07d4d186462e09b79acf9b72ecfe2831e3dca3daefa2ca91" => :yosemite
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
