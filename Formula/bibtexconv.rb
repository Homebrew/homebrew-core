class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/bibtexconv-1.3.4.tar.gz"
  sha256 "f921ae1a5065300bd81d36d8c8d1a0f366df049239d6f1337281de445036faf6"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d9c85fe7a60d47876f0b3a65a6d16ec09f60eb1526f474aa4e7444da4a0b07e7"
    sha256 cellar: :any,                 arm64_monterey: "9163d625133c3eb7d02abf6cc6f63436b597e7c9b01dc3dc1c71c99859dbde95"
    sha256 cellar: :any,                 arm64_big_sur:  "e267b9657835e14eafa69a790853664aae39755a0e9692640c5a33537ff285a8"
    sha256 cellar: :any,                 ventura:        "e56ae711439e7cab2c328d1de79cf73e719aa4059ae5c0951cf895797ff210be"
    sha256 cellar: :any,                 monterey:       "6fc4c03c5490aa595504c7ba933199e8aca57b6372b93a7183b7c53cd8c9f3a6"
    sha256 cellar: :any,                 big_sur:        "1d8ddfb750b024ccecf2040fc7f25c900cd00613415f9cd570d987fb2e0a34da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82994cb9d9f591a8d32f2592772dcf45b3db12c3ec94ac7b4c3a7f265298e5e3"
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
