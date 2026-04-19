class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.2.0.tar.gz"
  sha256 "841542821ae46eaf4065e6b3b62b5e9466e4c85c17058b1b9c42f69190bd0111"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "069a0fc2b599f0f372d301f1fedf08a29fbfc84c8dca341f8a20ad6a96aa368f"
    sha256 cellar: :any,                 arm64_sequoia: "de66963ec4cfa457d5adb9fbc0c1c6193a9c2e068b792a3709c64cff0b834917"
    sha256 cellar: :any,                 arm64_sonoma:  "33cb3528e8a521517b4b8de0862f6fc9f0fc19fffb8ce3b11e8343cf3130d100"
    sha256 cellar: :any,                 sonoma:        "8038763c7f02c880a67e402110977bf23b7591dcd96a58ba2b32dc4ccfb0b9cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3288fc1f6d00e924ae897ceb7061c27eb251f9a01b87faa63757f1afbeb0eca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "737b1cb149b274538819ad3c03b2fb6a4c6867b917211b2589a4bb3d00016177"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500
  end

  fails_with :clang do
    build 1500
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", testpath/"ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
