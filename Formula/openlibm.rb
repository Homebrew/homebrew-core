class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/v0.7.0.tar.gz"
  sha256 "1699f773198018b55b12631db9c1801fe3ed191e618a1ee1be743f4570ae06a3"

  bottle do
    cellar :any
    sha256 "a7d18405ee96e1409a3de89904263280b364ae5e0d046be6a1391031f6ec5bb9" => :catalina
    sha256 "d7f73575a6b6b7efb4307165f578e172a1563955ed476683b27bbaca6c0cafb6" => :mojave
    sha256 "4f769ffeda11f2bc17a5cd52a4bcd59723586b9258b789adcdb628fb700cca86" => :high_sierra
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
