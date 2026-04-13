class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-2.1.1.tar.gz"
  sha256 "865dfba8915fee593163251594afee461ec59ef438778224123180e435456323"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d02f4e49ab2c8badb1a1b94eef388d2f150905a32f8630c7a5ae3448953d995"
    sha256 cellar: :any,                 arm64_sequoia: "68ce278a641292125789717dbb5407f91a6ca8fb1b97e35a7ef13e0eaa2ec477"
    sha256 cellar: :any,                 arm64_sonoma:  "c7f394717dbfb4da8708e384639dd435ba954049cd342e346d51ca45ac496dbc"
    sha256 cellar: :any,                 sonoma:        "a78bd7f2fe47c74beef8c83681b9eb1d731982bf934febc9b8ac49471fde1934"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe77b85b8c2e746cc0651ff90df7a907d2a4932b2701cff2fac31f8c6a273772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44a41b83d68982f3d32f2824c35dd1bf8d9744b2f792b42a69614f50fc1c72ca"
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
