class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # Last known good original homepage: https://web.archive.org/web/20080906064558/www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://github.com/FastCGI-Archives/fcgi2/archive/refs/tags/2.4.4.tar.gz"
  sha256 "c0e0d9cc7d1e456d7278c974e2826f593ef5ca555783eba81e7e9c1a07ae0ecc"
  license "OML"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5dfbd8e646da528b2193e4259e80296c9cb1b311a8e0b2a8a5d76d59e452a829"
    sha256 cellar: :any,                 arm64_sonoma:  "edb585bb21c1fafba3124a4fcb285fa5e6074a264a0514c8616bcc38adcf9e34"
    sha256 cellar: :any,                 arm64_ventura: "a3849663ab04f777cbbeac683d41a01c16d4543d4a8973fb0c421a580f949244"
    sha256 cellar: :any,                 sonoma:        "da8530a044fb1de39e36cdbd7494e7c58d1a6e8f01cacfce567c0d8a1b19ab70"
    sha256 cellar: :any,                 ventura:       "448684742a94e680dd2d9e00d255898be0a4af34355b8f873232aeb1c4b59035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "429fed517696fe00225fb3cdf5552de904295b82526b87c0e887b7d5cd77b668"
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
