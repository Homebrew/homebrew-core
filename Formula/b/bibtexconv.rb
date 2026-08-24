class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.nntb.no/~dreibh/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.2.4.tar.gz"
  sha256 "c2a04a622c9ce612a73451cb6b7c206eec80e57b7e4940cc58e3a18d5e588270"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d560c331fff19bb700bd2dc7ef3259e72d94392b907dddc255235fa885ee95ea"
    sha256 cellar: :any, arm64_sequoia: "0a05f381a0251dd693a62483b3b6c236f340de879c3e10e12990de1442d5b45e"
    sha256 cellar: :any, arm64_sonoma:  "f72a8f0c9790d6a6e53a5203315a158e54d578192be145ec6b012497a82b2c9c"
    sha256 cellar: :any, sonoma:        "68a2cf8fe0a09cb49295d84c7061b9edf046668711d943210b0916491ff139ad"
    sha256 cellar: :any, arm64_linux:   "9bdc08148a87a83e43b2e38048faf2755f12101c4a7b6dac8a5628d7d6101f6c"
    sha256 cellar: :any, x86_64_linux:  "63216c6c8da53bfdb7409b186014798bf273671dad47c18775776aeb1e0095fc"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1600
  end

  fails_with :clang do
    build 1600
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{formula_opt_lib("openssl@3")}/#{shared_library("libcrypto")}"
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
