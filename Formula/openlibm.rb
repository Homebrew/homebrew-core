class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/v0.7.2.tar.gz"
  sha256 "7793eb5d931ad908534b4d69b12e8f0331d0c84cb56ed9bc165a820b643cd425"

  bottle do
    cellar :any
    sha256 "f1e3e0273605b2433a5d44d99a10d8dcb31631965dc8bf02e322aaa7d3cb124b" => :catalina
    sha256 "ad3fdd38f3f3e49739ade208a42d3212ded50bcff0aeda3593da46f162649398" => :mojave
    sha256 "051c797563aca3ae42f5aaa50e7f92bb5692716e420638b9f689302118604e69" => :high_sierra
  end

  keg_only :provided_by_macos

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
