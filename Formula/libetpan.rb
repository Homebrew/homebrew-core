class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhviethoa/libetpan/archive/1.9.2.tar.gz"
  sha256 "45a3bef81ae1818b8feb67cd1f016e774247d7b03804d162196e5071c82304ab"
  revision 1
  head "https://github.com/dinhviethoa/libetpan.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "98f05589259d5f285335a2ded65429e9f00213ec2b2ecf12b3d989477d75931d" => :mojave
    sha256 "0f46d1f2eeffc2128e9a982e2c5eac22de3c56559ce1cd1076fa273ab1058782" => :high_sierra
    sha256 "c6a39364b0652b0b80fb1cb4affee5de19d4bbcdb3ee1946f270bb5c90e8b982" => :sierra
  end

  depends_on :xcode => :build

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
