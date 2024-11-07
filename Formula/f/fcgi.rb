class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # Last known good original homepage: https://web.archive.org/web/20080906064558/www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://github.com/FastCGI-Archives/fcgi2/archive/refs/tags/2.4.3.tar.gz"
  sha256 "5273bc54c28215d81b9bd78f937a9bcdd4fe94e41ccd8d7c991aa8a01b50b70e"
  license "OML"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b243ed770f2e7ac1ada1a8cdb9d24fb6f5fd7f29546a4e09dd5c8be9522563a"
    sha256 cellar: :any,                 arm64_sonoma:  "10d1524cd9c606406a3b410b852444f5f4be6bee4f628f85f04b72519c15df2d"
    sha256 cellar: :any,                 arm64_ventura: "19c601d9f25cb7d96a0fa63cc94330a48bb059f90422da9866aa8f07afc6bfdc"
    sha256 cellar: :any,                 sonoma:        "b12ff1ea9af17f7357b48437cdc56425942fd5438683844af01e6423435fb08d"
    sha256 cellar: :any,                 ventura:       "5c49c7a4a84514bca3938a3525cbce741d1d8ea6403a11a653779e858d9a43c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e4bb7c9d5baade09a78176687e126eabccd43b892086a3bccbf1384a39128fe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"testfile.c").write <<~C
      #include "fcgi_stdio.h"
      #include <stdlib.h>
      int count = 0;
      int main(void){
        while (FCGI_Accept() >= 0){
        printf("Request number %d running on host %s", ++count, getenv("SERVER_HOSTNAME"));}}
    C
    system ENV.cc, "testfile.c", "-L#{lib}", "-lfcgi", "-o", "testfile"
    assert_match "Request number 1 running on host", shell_output("./testfile")
  end
end
