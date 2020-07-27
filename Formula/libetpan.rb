class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhviethoa/libetpan/archive/1.9.4.tar.gz"
  sha256 "82ec8ea11d239c9967dbd1717cac09c8330a558e025b3e4dc6a7594e80d13bb1"
  license "BSD-3-Clause"
  head "https://github.com/dinhviethoa/libetpan.git", branch: "master"

  bottle do
    cellar :any
    sha256 "2effe5528f31ea1edcdd0baf468bb1ebbfb0061cb8bf131f2636b5db6cc20550" => :catalina
    sha256 "ba4948b8f0169ee43ba18b0dbea0564bfd5a2c625834f6f5a5c4b9ac1d725334" => :mojave
    sha256 "6a2f29f42a39d9d3eee7bca1974118fdd8d44a745f61af686aa40c449157b733" => :high_sierra
  end

  depends_on xcode: :build

  def install
    xcodebuild "-project", "build-mac/libetpan.xcodeproj",
               "-scheme", "static libetpan",
               "-configuration", "Release",
               "SYMROOT=build/libetpan",
               "build"

    xcodebuild "-project", "build-mac/libetpan.xcodeproj",
               "-scheme", "libetpan",
               "-configuration", "Release",
               "SYMROOT=build/libetpan",
               "build"

    lib.install "build-mac/build/libetpan/Release/libetpan.a"
    frameworks.install "build-mac/build/libetpan/Release/libetpan.framework"
    include.install Dir["build-mac/build/libetpan/Release/include/**"]
    bin.install "libetpan-config"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libetpan/libetpan.h>
      #include <string.h>
      #include <stdlib.h>

      int main(int argc, char ** argv)
      {
        printf("version is %d.%d",libetpan_get_version_major(), libetpan_get_version_minor());
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-letpan", "-o", "test"
    system "./test"
  end
end
