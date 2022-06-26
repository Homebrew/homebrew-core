class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.3.2.tar.gz"
  sha256 "6eb1c82a8287ae749ac129d48c241c558881385a792dcc800a30809caf2a2109"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eae3c4722d3b824dcaeb36ee02f1ab5fbd7e837ca540a98ac37a68a95ca66084"
    sha256 cellar: :any,                 arm64_big_sur:  "32369759a62181680a6146a975b36f7712ca2dc96a2d645772903d20d1394eb2"
    sha256 cellar: :any,                 monterey:       "0e738cb15ae6d4c43221401bba7501138159ca03b53f78271e73a0394729697a"
    sha256 cellar: :any,                 big_sur:        "0e216e19ab0dc2b63c660892b8503f493f101437386da8239ea2c18b5b511ebf"
    sha256 cellar: :any,                 catalina:       "d1a4b531a508711d1524b89ef21d2a1a1818453548c14d99c4ed09b1d05bbd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d4960851c348c9a2bd2b981fd110ef2de2d1aa0ea6d2ea2a588ad1328a74c10"
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
