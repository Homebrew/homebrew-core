class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # Last known good original homepage: https://web.archive.org/web/20080906064558/www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://github.com/FastCGI-Archives/fcgi2/archive/refs/tags/2.4.6.tar.gz"
  sha256 "39af4fb21a6d695a5f0b1c4fa95776d2725f6bc6c77680943a2ab314acd505c1"
  license "OML"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ed8d432869c4ea3a09fc5ec208e99aa697c633dc61bd71b69a9da030e3fc5f41"
    sha256 cellar: :any,                 arm64_sonoma:  "fb107bbd82683ed34b343e66b5227734edd67380e6b993e9d264f0ca2f895bef"
    sha256 cellar: :any,                 arm64_ventura: "948d174933e9ddd554445c66968fd12729e8a1c00472fbcdd7baef471b61868d"
    sha256 cellar: :any,                 sonoma:        "62fdab7bea62b4489886074d78558ea4960fd18f6e3c12442e4c1a7871ef57fb"
    sha256 cellar: :any,                 ventura:       "167bd3df5580c090ef7ba7c6dff6822bea66911b0dc22b576ab22459392bda62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbe3f5ef9b002e1676874646194087a55dde28e73ed4d9f68d9d4d61122b4b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4282f27f24837394e8fc3ad1c5ce619c4f1ab9cd0069676d205c1c365218aa1a"
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
