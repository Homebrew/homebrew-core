class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.3.5.tar.gz"
  sha256 "e59fbe23589d66270032904ea48ca058cb63fdb77a6e956cfa181173a697127b"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "67b5d947b9c1c40260774a2fffd74b7a01d4c22c5fe6b193d954dc9959fdfea0"
    sha256 cellar: :any,                 arm64_ventura:  "1b1e350438a1fe6c66262200b9097c2937b521b6387252108e0560f2194af50a"
    sha256 cellar: :any,                 arm64_monterey: "342ea2746d149a01a53c65506a9b50ce18bb447743f741f9d3bd4c9782822266"
    sha256 cellar: :any,                 sonoma:         "c21102dab4b0815b3f8396b889e0e6e98ed4a1dc48040d964d512e5097736fe8"
    sha256 cellar: :any,                 ventura:        "3827de0dc585f8a8cc8976504e5b56cb15d039a4f3c9e02615cd4648939cc709"
    sha256 cellar: :any,                 monterey:       "337326885c7c4a872f4252ddbaf706cef0152c5546e498a743a921f73a600440"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7f7c7dd0da2f02362cfc65e05cbf840e99f89692fa78a0ade3ff14b840125f0"
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
