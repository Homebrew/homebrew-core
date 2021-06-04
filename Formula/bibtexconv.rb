class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.2.0.tar.gz"
  sha256 "0ace3aa17eedbc4c4950e5ef8763b1dd58bfa2d33cd00fa2b35f07febb6df940"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e1695a1a03185cbf7f50c031cfab3d77777a6c8bd47c88ea1799fd097d4b8dfa"
    sha256 cellar: :any, big_sur:       "aaab664beb497d6f9c7e84e7e3cf72fb68bbd813c3398e7b561b7fd611a5ed8a"
    sha256 cellar: :any, catalina:      "5b9d6cc6d178116fe7e18d87c807cd4427d105e450feb0bd10a1649d64f61ed7"
    sha256 cellar: :any, mojave:        "01522a08151261c2fb84298b690e00ad4699285ccfd2e2b021baedb1b6174bb6"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"
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
