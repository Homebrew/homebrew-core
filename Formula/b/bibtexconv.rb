class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.2.2.tar.gz"
  sha256 "352fb9757d25ce4b5f1ef3bebe70e55e27d01b78211aa1ad05efea18415d3d09"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3959447fae5909ab2c0841acdf07a4229f61b0f91e600e9693e74ba90e6201f8"
    sha256 cellar: :any,                 arm64_sequoia: "dfe98ebf085370d2728fc0d296de340f7e6c7809136ea4a457f3cb0eb34bf7a6"
    sha256 cellar: :any,                 arm64_sonoma:  "83ac4fc7fa37b15bd722b387a43baf0f760630ee37051cb906a53fb91cc29fa2"
    sha256 cellar: :any,                 sonoma:        "be8cbae61bd9a9f1327f5c2e88f9a649979a8fcd9111a7e8469de9f476dd0286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f707c7ed9a788add1a3aba7d14998c6d005b17cc4c56b4b8a79d57642d6232d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8035bb9a8d8f73304c7a6e92bd9b938ec9636c854aadb9607763867e1163a11"
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
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
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
