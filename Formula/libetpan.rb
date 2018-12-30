class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhviethoa/libetpan/archive/1.9.2.tar.gz"
  sha256 "45a3bef81ae1818b8feb67cd1f016e774247d7b03804d162196e5071c82304ab"
  head "https://github.com/dinhviethoa/libetpan.git", :branch => "master"

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "build-mac/libetpan.xcodeproj",
                       "-scheme", "static libetpan",
                       "SYMROOT=build/libetpan",
                       "build"
    xcodebuild "-project", "build-mac/libetpan.xcodeproj",
                       "-scheme", "libetpan",
                       "SYMROOT=build/libetpan",
                       "build"
    lib.install Dir["build-mac/build/libetpan/Debug/{libetpan.a, libetpan.framework}"]
    include.install Dir["build-mac/build/libetpan/Debug/include/**"]
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
