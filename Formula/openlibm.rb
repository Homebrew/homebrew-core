class Openlibm < Formula
  desc "High quality, portable, open source libm implementation"
  homepage "https://openlibm.org"
  url "https://github.com/JuliaMath/openlibm/archive/v0.7.3.tar.gz"
  sha256 "d3bcc4ef21c033a0cc408a30186bb3dbe21219e0c52d328ca70eb688cf867354"

  bottle do
    cellar :any
    sha256 "325d0ffd1c5d9ea2fa7c024718fdedbb422cb0413a3d2af4a049721259123605" => :big_sur
    sha256 "892a6ecb5cd33f2c315331158c9d91138f46fd6bc75f7c85d30ae9da90580eaf" => :arm64_big_sur
    sha256 "7ba4146b71d0ec4a4357bb04a000651b8acf7c4d788c754609cfe3ecb2edf907" => :catalina
    sha256 "440a34d2b12672d844a12b1b9dee61e41920a60d1a743c5ea65f864a592bf046" => :mojave
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
