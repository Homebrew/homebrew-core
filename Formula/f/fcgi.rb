class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # Last known good original homepage: https://web.archive.org/web/20080906064558/www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://github.com/FastCGI-Archives/fcgi2/archive/refs/tags/2.4.5.tar.gz"
  sha256 "92b0111a98d8636e06c128444a3d4d7a720bdd54e6ee4dd0c7b67775b1b0abff"
  license "OML"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "34f082097676baff0b47855300530262e14386ec19caf9548c2d5372f81cfb1e"
    sha256 cellar: :any,                 arm64_sonoma:  "85d92294163c71204dd906d2981769bf91a67a30a7711a42643aa7fbd21d431e"
    sha256 cellar: :any,                 arm64_ventura: "3439d34ddf21085d29c6324afe75f8d1076506e5dfc8f1e7f23041980df1f525"
    sha256 cellar: :any,                 sonoma:        "7dce315b80b3d71731b116e45cd0d9c2bc6f32aacd5abb5bf6b9238e0eea3ab2"
    sha256 cellar: :any,                 ventura:       "b2df84f6fd958d226f1a1cbd10450d72e0978f85bb68b4172be866b8b09721f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e53ecb86992a7e45826693cc19d9581e9ecacd4479f7d306e0140010d4936ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1ccd1124482f802cc64434f9ef57882fae188f770d92d7b71193944a7823b34"
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
