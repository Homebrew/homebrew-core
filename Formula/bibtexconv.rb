class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.12.tar.gz"
  sha256 "dce954b9e81b31f9b2aaaac4a4b1e528d7cc901376be095b40ba44525db3fd76"
  head "https://github.com/dreibh/bibtexconv.git"

  bottle do
    cellar :any
    sha256 "2b44b8dd4bf60b443c9318e056fdcffaed9218e75d7d907dd6ae5c4679a135e9" => :high_sierra
    sha256 "81c4daa41ddb6837d40b66a883aceeb3470ca03148fcc6fd19386ff623776dd8" => :sierra
    sha256 "397edcb9360918833774139e8cf9d11bcb53fc7c763e487a7bec325861b73cd6" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl"].opt_lib}/libcrypto.dylib"
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
