class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.3.3.tar.gz"
  sha256 "c0ce86b5f1eed75ed77cb5cf7c4f3dcea2a7bab512c4ed43489434a21a7967a4"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "13730483bc2b871a057dcb28a2cd5b4463aa3d094cacb689a0a486c3ee4047f8"
    sha256 cellar: :any,                 arm64_monterey: "d7c6015e882860d515b54a3e6a6a6abb7c4edd7961becbc0d95a11f4a0dff77a"
    sha256 cellar: :any,                 arm64_big_sur:  "8d4e447363f8766392f2bfa002064d4b6d2fafb1da008b2dea974f667556ee69"
    sha256 cellar: :any,                 monterey:       "ebb0bfcb99948aae3a54efa62e20e846ec5e22a5e5bdfe6cf6d88107d91da4be"
    sha256 cellar: :any,                 big_sur:        "39e037b0bbe3f988e9cf19381ef6307f25fdebdaa3f58222ec0261daeeefe0c2"
    sha256 cellar: :any,                 catalina:       "eae65bd16d3413b0e5de89afffea434da1dcb687d55a12f241270fa181f74b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccb78d8a1951b4e9e2fae9482f0daf5fd1678e06302a14d313c21e024c6bdb27"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
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
