class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.0.2.tar.gz"
  sha256 "c9c01c3cd973a773af0b9854f08df31c34c64e6c118b3400db31b4d7fc2ae235"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fbc4cb16c766ea1a4de4122bfb71200e73c05f52a0be544caaf2744d4a8eee51"
    sha256 cellar: :any,                 arm64_sonoma:  "6647b330cce25a922b9a5208e760fef00487d8b7d6046450292bbcb2f1d6bd0d"
    sha256 cellar: :any,                 arm64_ventura: "1834aeedf88c98f331c08e4f2e0f1e83b48e5a7e5525b16456396705b0d4c139"
    sha256 cellar: :any,                 sonoma:        "b3eb3ed7dc704e829491462fe927a41b61d3d96fd5e56333220410fe428ab014"
    sha256 cellar: :any,                 ventura:       "3d68a045124eddc823b08c7d256aecda7267963c95b5ace61d1c95e10e4a1dd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91d5174a92ecde399224489caf3d9d853a6ab40598c2868331bce68d4fcaa906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29113580365e674fa8ab9cda06930f95ce61c103e22c6ea33257b9bd61919079"
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
