class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.0.4.tar.gz"
  sha256 "0e934d3c2c6202eb2ddffc8ac20325655e97cc9644afd024a171f06800eb6744"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "203f3cbc00d8792e3823a38cdb785e56b90235827df7faeebe0f9c566cd96e45"
    sha256 cellar: :any,                 arm64_sequoia: "ab42072983b84c5a48635b8eebf1b2491e2a043d5e394f73637d17ef8e81b5fe"
    sha256 cellar: :any,                 arm64_sonoma:  "a62d714437cc8375998c8a252be0b91f31c74d6ce822d0e2b69dcee0b313b68c"
    sha256 cellar: :any,                 sonoma:        "a6df7c66eadb90c4efe4acee1a1725e9ae6b210b6c1b1975f0c564dcdad686a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a5f43b4868a4ed8991485b293f3b0bd366fb5baa3008772f1775bb341a97e5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad40667baa9dcac9eec0e2bef0a221ba3c25fa45819bc70b158c2e879198e16a"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
