class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.3.1.tar.gz"
  sha256 "db08bd2b21b137c073ceeb97e5c7f68be4994d3e2af7a8c7dda088ccc0dea9b6"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cb29d459522a8807ad4bcda6d0ad137782794a720d5735506385f3353e9299e7"
    sha256 cellar: :any,                 arm64_big_sur:  "d7cf921f95e927c2e4a238786d2f4ad1627105a3711167af39fc9d1733064cac"
    sha256 cellar: :any,                 monterey:       "d6db04dc263581b3a1a826703453ea6678e43ab4d74a68d2c029563c1ed1d835"
    sha256 cellar: :any,                 big_sur:        "188668f5f42b00871cc8fd81e7856ee94363588f9328dbb4c27f77f251d6a950"
    sha256 cellar: :any,                 catalina:       "27540958843cd41d831ff19c9def9d9d066b75f43e7345aa9ebe7761c4f3dc92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "452b47a0b63d4e02abb780b3ce4b2cd1cc031c6d64b2c6b34c53c807e29b75d8"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@1.1"

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
