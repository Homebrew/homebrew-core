class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.1.18.tar.gz"
  sha256 "b49ab771c53a6542fb182439dffdb1bcc2260bd90046a50ac2b0491d886a3407"
  head "https://github.com/dreibh/bibtexconv.git"

  bottle do
    cellar :any
    sha256 "6d508d4203b332b98936347000fdc500286985c5ab9dc0ec4cfac1b532380629" => :catalina
    sha256 "69f25d3c58a9298b374fb41a407db1341090f6a5c9468fb98883fd4f75e3865f" => :mojave
    sha256 "749f0b6e565679be02c3ea13cae96010f8b5bbe30308ebc3334232a79efc6e3e" => :high_sierra
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
