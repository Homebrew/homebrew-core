class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "7244f9aa468584744e260cef740d57d10eab6e9c05f62084f8f2ba457f4b4b1d"
  license all_of: ["MIT", "ISC", "BSD-2-Clause"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "435f9020d1297471c2fff357cd441914bc9330830afa4a58a7794a47d3ef6098"
    sha256 cellar: :any,                 arm64_ventura:  "1fcb943a2b0b8a013db3d157a6cafbc08d03c7cf3c554918aacd9270c2d96de9"
    sha256 cellar: :any,                 arm64_monterey: "551a339e3d2c2e06ce625b5dc51e375e290a61801c508b351bfc690890f1fa26"
    sha256 cellar: :any,                 sonoma:         "3330d9dba6af55a5d1fc86f471619e1999049964c91e451e1eb02f6de7920c75"
    sha256 cellar: :any,                 ventura:        "9d88f67464be7f2b245cd9f7f47e6faca6c12288ed71e1c83dc7a0580f1d266a"
    sha256 cellar: :any,                 monterey:       "a073965d7967121a63a63b0ab888df1b46e64e5b86e4cb0dfe1337a4eae4cda8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7efc8d98d0cbf005e186fde4b9cba73dc82921f2d31634adac1546b473fc8de"
  end

  def install
    lib.mkpath
    (lib/"pkgconfig").mkpath
    (include/"openlibm").mkpath

    system "make", "install", "prefix=#{prefix}"

    lib.install Dir["lib/*"].reject { |f| File.directory? f }
    (lib/"pkgconfig").install Dir["lib/pkgconfig/*"]
    (include/"openlibm").install Dir["include/openlibm/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "openlibm.h"
      int main (void) {
        printf("%.1f", cos(acos(0.0)));
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/openlibm",
           "-o", "test"
    assert_equal "0.0", shell_output("./test")
  end
end
