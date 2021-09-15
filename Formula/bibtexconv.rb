class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.3.0.tar.gz"
  sha256 "1d15a474f723ef251eb0ad13fc3578dac7b17504b4d8de36bcde7c1584a48852"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "75b1b0a5166222d906d2fa962f5617ee8e2bcb67e806bc90213fc618a8107498"
    sha256 cellar: :any,                 big_sur:       "483f1ea3375504b76437e54d3b20aa867a0153c0e273646494aad63b9aae1680"
    sha256 cellar: :any,                 catalina:      "d14665d2cfd8c82a44dd80fdabe428c2af7c2a8ec686e7d9122e1590de7accc9"
    sha256 cellar: :any,                 mojave:        "b086275062e61738d48b34c87a15896ff0d32db7f89819a137cd2b0a91079f8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9d4aeb501f8a5e0bb54ab68f2907503df017a4b18b68f63a97099cbafe591c"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@1.1"].opt_lib}/#{shared_library("libcrypto")}"
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
