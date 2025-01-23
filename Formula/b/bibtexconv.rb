class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-1.4.0.tar.gz"
  sha256 "6c46ae8b439058183c0e2769f4cacabe5bc573f128de28cf70b53937285996ac"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6ec5158c13d40a617a2b1fdfd4cc8008e947f5b967f4c0daefbb93d89955a2a2"
    sha256 cellar: :any,                 arm64_sonoma:  "f8fb09a09809a9f793d0f44397d47ccee6fd04bda3903f69af180e76f2e5ff73"
    sha256 cellar: :any,                 arm64_ventura: "3eceb67bd7666ead9340f60cb75c18ea072f96c6248f234b2149f4f286efe349"
    sha256 cellar: :any,                 sonoma:        "531660b392b4d038edb3567c43bbc98ea6d703fd264c2063bafe5ccc70dddbf0"
    sha256 cellar: :any,                 ventura:       "0701b6f867f4fa486d7eef9aeeba466935d62655f14249530c8baa17beef7693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a7344ed47b8211a7852ecdceea9841c05ad1f60f468b880ff409da152281f2f"
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
