class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.1.20.tar.gz"
  sha256 "5fbc14d0181ec7eeb024a628af070ce7286f2cb92147c3ffa8504201cfcc3f8b"
  head "https://github.com/dreibh/bibtexconv.git"

  bottle do
    cellar :any
    sha256 "bd1a809b90e1092407e7a81fe30aca8f8df52791fa701afc7b65c4dc74f6f5d0" => :catalina
    sha256 "b8f6412efed90b19aff5945ab58113ae7849f338527a801e48f531a31e289bc5" => :mojave
    sha256 "294bfcaa004f25eee6806d01d80dce51a3e88e172034b2696247aa2c8776196b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

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
