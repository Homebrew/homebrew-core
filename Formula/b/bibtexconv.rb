class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://github.com/dreibh/bibtexconv"
  url "https://github.com/dreibh/bibtexconv/archive/refs/tags/bibtexconv-1.4.3.tar.gz"
  sha256 "06c2998aa849b2ef19902dc3ebe910eb164543c3f864c4ea29402d75a519e09d"
  license "GPL-3.0-or-later"
  head "https://github.com/dreibh/bibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0478d3aff5514efee5d780753b03b8054aa4da807ef6aec65719583a505bf092"
    sha256 cellar: :any,                 arm64_sonoma:  "027884416e09e8e4ccbe81cbedd31155df48caca196717ba3bc932ef91e37afa"
    sha256 cellar: :any,                 arm64_ventura: "fb3a73be47b67d2b450d704b65a32374187608c1b1ca5656fd397cc8fbb99269"
    sha256 cellar: :any,                 sonoma:        "a43344cd2bbb10f7a5ef9b696027977f7b80961e8a5b2913e1600c8997e0b53f"
    sha256 cellar: :any,                 ventura:       "5f51662a73ef80bbf3a7d23838e6a9b32f2c190dc146e9e2f7656d37bc6582a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a6ba5f43840616a92558851dedfddf7a164bcf206e4a3a4c77fbd5f687bda934"
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
