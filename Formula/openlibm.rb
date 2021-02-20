class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/v0.7.4.tar.gz"
  sha256 "eb585204d6c995691e5545ea4ffcb887c159bf05cc5ee1bbf92a6fcdde2fccae"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2046c2a9f7874150036e25091ea934377c7579f0396ae7570f4c2ff350bb6094"
    sha256 cellar: :any, big_sur:       "efd441cb260e064ee213c0c7008c02baf6c552d4ea45afc11c6df26371032131"
    sha256 cellar: :any, catalina:      "23ae6cbf040c349d0bab99cfe267f2a416c1a24a804724543687d748ab55cfaa"
    sha256 cellar: :any, mojave:        "42e992c9bee0975fa22df4313c80180c08a772fe7b1345808a61c469b00e2044"
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
