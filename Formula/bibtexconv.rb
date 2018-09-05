class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.12.tar.gz"
  sha256 "dce954b9e81b31f9b2aaaac4a4b1e528d7cc901376be095b40ba44525db3fd76"
  head "https://github.com/dreibh/bibtexconv.git"

  bottle do
    cellar :any
    sha256 "ed2cf1c4018b8605632c7d771da2eee7212ec1267d459fe77e1b1fd27ecafeaf" => :mojave
    sha256 "ff0392f367020e150acc25eb36a5020ae78f43c97450ff144654d1c55da362c5" => :high_sierra
    sha256 "22bef646b19754ee426d9e98158f1bbd7e18b59f674abc0c1c6f7c4012511122" => :sierra
    sha256 "824b5ec5e79e9624510c834aa0ce76de90c3bb63100c4e995927fa4b06905706" => :el_capitan
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
