class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.0.5.tar.gz"
  sha256 "781ea738b0665fd9e8bb6f345a2a411036da0f8dde0e554652f55568aceb3f52"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ffa6e1a42bf433037c48b0d3792741ffc32d8afa443f44a30caf054192990bc"
    sha256 cellar: :any,                 arm64_sequoia: "029c8abb57ff20e462b1907f3fc8400cea94b7f079740c94d258cfbc910a6195"
    sha256 cellar: :any,                 arm64_sonoma:  "3ab14661da49ecbb4bea996ebed7abb4453aafd40a9895306f9df84882b4698c"
    sha256 cellar: :any,                 sonoma:        "1829fc58a3c86283faa52c6242c132c99da7f6fe5016bfbeb5dacfa6fbfc10bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "880620b75a4a767e0e9b8d3f9097a74d75db9c63bdd53f04ba8d4fc67430efc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "458a70adf351b0efb63f7090fd73fadb730eef6530188ae116a1c4caa1217667"
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
