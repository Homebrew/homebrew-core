class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.0.1.tar.gz"
  sha256 "b85d71000b5b41949adec1165138b68da2cd831da815ca64523dc9843b979c3c"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7a646fda03a468c4cfb0b012f6df3f6cecd3740db220e79d45eb37c1709e67fa"
    sha256 cellar: :any,                 arm64_sonoma:  "992439eb9d494474b58380fa04b19be22d7c0b2329b1e9455dfe0a924f49979a"
    sha256 cellar: :any,                 arm64_ventura: "24d29ca3f88714d1ec8771a49e6d629d1b54d3f43b38ba15bb91267e7729483c"
    sha256 cellar: :any,                 sonoma:        "b7cad797ef672b779b7f1beb0a7aacc88c8e8c962544bea829b53f36761fcaa8"
    sha256 cellar: :any,                 ventura:       "b58be8c6d279e88679518486fe52f07b511c4ef82409032f8a035daef93ac65f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72eb9653e3410802be1ac658103b7d0bbf2bcd68319af951afddc2b6de86ac4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "855b81063a70f1bc3eea9758c1e789085b1f290de8c16e27747082160586cde2"
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
