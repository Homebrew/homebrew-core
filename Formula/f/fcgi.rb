class Fcgi < Formula
  desc "Protocol for interfacing interactive programs with a web server"
  # Last known good original homepage: https://web.archive.org/web/20080906064558/www.fastcgi.com/
  homepage "https://fastcgi-archives.github.io/"
  url "https://github.com/FastCGI-Archives/fcgi2/archive/refs/tags/2.4.7.tar.gz"
  sha256 "e41ddc3a473b555bdc0cbd80703dcb1f4610c1a7700d3b9d3d0c14a416e1074b"
  license "OML"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb43b24ff7e561b526e8f85a3c04a855b7696e77a8150b8668407dabaffa1c8c"
    sha256 cellar: :any,                 arm64_sequoia: "048a15902fbb7994659f3a3938c5aee8341a92310dcae1faf0f5cbbff909375b"
    sha256 cellar: :any,                 arm64_sonoma:  "4a2edec9c178ab10694ec0a3204a40ccaac5759522d20a7fd6d33b7ccd31868a"
    sha256 cellar: :any,                 sonoma:        "e6e30220570ac467e115490979060b091d3d54b6f82995b7779b5f7e91fd0abd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c0f414d30d3556e91bec294ae0025c954c21d0cdc3cc5125ab9061fda0574d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1571a2ab11498d22cfe56ea3a859e864e835e5ee3fbb6634a10d82f6214008dc"
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
