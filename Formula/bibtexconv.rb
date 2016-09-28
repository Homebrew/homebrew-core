class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.6.tar.gz"
  sha256 "3a60247b4c007ced3b2833dfb5c142535318bb5a8bcd3f46a528c750ce58ee71"

  bottle do
    cellar :any
    sha256 "837cc801cd0c29024e198c142a6d66ba765e504a18cd36034d58bc11464f9e80" => :sierra
    sha256 "b0eae23ea87d29381f65d549fa1316382c2756b358a2c9afc86cf38b3230103f" => :el_capitan
    sha256 "b4a0e0cdfdccc456be7f2176965a3646eb8a13a1a1ab4c16726e15107fff1a11" => :yosemite
    sha256 "a0f3910b6680610f45a051dea0809fd696075e2dc7e4958f37ca013e2675eac4" => :mavericks
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
