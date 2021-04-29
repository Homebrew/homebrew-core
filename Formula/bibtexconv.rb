class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.2.0.tar.gz"
  sha256 "0ace3aa17eedbc4c4950e5ef8763b1dd58bfa2d33cd00fa2b35f07febb6df940"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "61628b4d7ad5508ba641b305478fd6f457e30e73c23c22bd69883237c918ce22"
    sha256 cellar: :any, big_sur:       "00f142e76fa6306e5de3ea352f81c8061119a8abdba4ec678f9c74efae97ca56"
    sha256 cellar: :any, catalina:      "989c035897f4c7ae44ccffc47b8bfcd7f52cedbe7cdd7bf909c994892a447262"
    sha256 cellar: :any, mojave:        "d6ebc4679598215456f0c608430b58621b8404f1fb8f467d14da6353b7f8478c"
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
