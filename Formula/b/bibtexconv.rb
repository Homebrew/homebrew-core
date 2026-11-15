class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.nntb.no/~dreibh/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.2.5.tar.gz"
  sha256 "5d766ec9af261288a71af9d389b407ebdf3a5f5739a166be86e355f2304c7843"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "efa081db50f71a712a4245a18d387216fa5326514df658f40f2c95b61aec571b"
    sha256 cellar: :any, arm64_tahoe:       "f15302fd9f3211df13c0ee81693aceaa933a76b51a0e22287fc0216e157d9a45"
    sha256 cellar: :any, arm64_sequoia:     "97c864858aaf0f2d44dba852e86e7c98797f039bb2b01f161ebe7edc9573f7c7"
    sha256 cellar: :any, arm64_linux:       "69fa5a3c65dd9609e30bc4fcf1c726dc93b9d76e8def2fbebbdddd30b41d210e"
    sha256 cellar: :any, x86_64_linux:      "40071a18be50e6f73751926c6c7464d16baa25da36061c5c0ca5390ac6253e87"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@4"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{formula_opt_lib("openssl@4")}/#{shared_library("libcrypto")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", testpath/"ExampleReferences.bib",
                             "--export-to-bibtex", "UpdatedReferences.bib",
                             "--check-urls", "--only-check-new-urls",
                             "--non-interactive"
  end
end
