class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.3.3.tar.gz"
  sha256 "c0ce86b5f1eed75ed77cb5cf7c4f3dcea2a7bab512c4ed43489434a21a7967a4"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e699763d13690a230cf2a280ea0b3e096be5e793a0ef37d68fe134e4e6256f4e"
    sha256 cellar: :any,                 arm64_monterey: "c2e6b9a91b14e08c20d8540ed7c7f55876ef4ce4aeb8a609355950c6b7761fbd"
    sha256 cellar: :any,                 arm64_big_sur:  "ba5a0696961b35cf63415b5f76cff2e3da8a53665dc08865aae498438ddd3c49"
    sha256 cellar: :any,                 monterey:       "14cfdc9391afdada9d5e87f83b73b5efcb40048c653bb9db1ccd262920005484"
    sha256 cellar: :any,                 big_sur:        "6391b2d3a13681ef85be37aa6d406bd842fda6ffbad19b9cc6888791bd456739"
    sha256 cellar: :any,                 catalina:       "02e854e05769f075e9cc192b4182a631252f84069037d9faef64092451812684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843ad83eade84da2672051adfa92cf57650c6b52a1d89b30e7871fcf037794e2"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}/#{shared_library("libcrypto")}"
    system "make", "install"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
