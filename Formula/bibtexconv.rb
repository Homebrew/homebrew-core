class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.1.19.tar.gz"
  sha256 "1f502da0452c9ce164d91ca5882ced80705a70863db0a8b0d118f94f766f4576"
  head "https://github.com/dreibh/bibtexconv.git"

  bottle do
    cellar :any
    sha256 "842b74aa1e1479877d0d874391b2c0e1ded01b09ea3ba16116d5048e3da935a3" => :catalina
    sha256 "46269fca6e00ebbe9e21e7344e6fc2f8f32b976fab0b7f55318ed46837d1b894" => :mojave
    sha256 "d733a3d076879577bd69bd11d8624389d1de7e974b1d443981ca3a5a827c2a7b" => :high_sierra
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
