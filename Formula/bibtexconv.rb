class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.13.tar.gz"
  sha256 "90d9a65ef6cbb9e61197a54c292105981b5a3528268f76eb61067112332f4538"
  revision 1
  head "https://github.com/dreibh/bibtexconv.git"

  bottle do
    cellar :any
    sha256 "6f6011d0f4881805977ee882cdead5e69222b3a8d119d27ef9b3895f8e63b288" => :mojave
    sha256 "96eda092763e70b1af132b834a5f8bb9c9f12ad6f2f0802e3c09d18ebf2f6115" => :high_sierra
    sha256 "210b19d5a4d6b38a544f677d87e59d0909ca727fd4c0519d8be38174a0e07af1" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@1.1"].opt_lib}/libcrypto.dylib"
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
