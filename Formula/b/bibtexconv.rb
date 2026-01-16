class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.1.0.tar.gz"
  sha256 "7c895e4882bd34bbb0ec90ea75ff1b0129055bd7573441c8118e6d0a7a1a1972"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45a95bb7a8a8dfe45c487492b45e5c4fd7b505245d7fbb75573f8920ed372685"
    sha256 cellar: :any,                 arm64_sequoia: "ef83949886a9df6ad67712c7b3741440e3a88e9fb8186763f44a06b177730188"
    sha256 cellar: :any,                 arm64_sonoma:  "3222ca853330e6e3026d22f7112c3531a0107193d50e0647e5c2095b6faaef78"
    sha256 cellar: :any,                 sonoma:        "f4c83f9991e98525b650197a2d2da6e26776f033e0812543023db31311a10c0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c509ca9b27b37a656d244e49db3be1e5b7f8ba6122970e57e7b9cbb492997f2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6ae4fb4dc3241494e58deeeace67041ec547560b966b2fdea20f27381e4edcc"
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
