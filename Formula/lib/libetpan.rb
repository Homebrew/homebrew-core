class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhvh/libetpan/archive/1.9.4.tar.gz"
  sha256 "82ec8ea11d239c9967dbd1717cac09c8330a558e025b3e4dc6a7594e80d13bb1"
  license "BSD-3-Clause"
  head "https://github.com/dinhvh/libetpan.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d5a028d25df2cfef1f146a27024b8a1a111d5d939a9678538b02649a35c2da75"
    sha256 cellar: :any, arm64_monterey: "772546d5dd375facff503b9d1fb5618b9ebc49e6d0d8c04250edc7bcc60cd115"
    sha256 cellar: :any, arm64_big_sur:  "c72a2eeaf1b3fd67a093375fd567ff97c329d5d503abd720572eefb8d88acac3"
    sha256 cellar: :any, ventura:        "8e10bb7d65a748f856d0bc05ad843f35836cf444bf55aa286ec5c17590a3e73c"
    sha256 cellar: :any, monterey:       "58fb1bf8eef4740ab4383ec37787e7a5885198e48d3254c1811c2ac70ff1c174"
    sha256 cellar: :any, big_sur:        "9d2ac6a48a6c14f2894155162d52ad7e8cf219ab21245b429b83378662f4a7f7"
    sha256 cellar: :any, catalina:       "2effe5528f31ea1edcdd0baf468bb1ebbfb0061cb8bf131f2636b5db6cc20550"
    sha256 cellar: :any, mojave:         "ba4948b8f0169ee43ba18b0dbea0564bfd5a2c625834f6f5a5c4b9ac1d725334"
    sha256 cellar: :any, high_sierra:    "6a2f29f42a39d9d3eee7bca1974118fdd8d44a745f61af686aa40c449157b733"
  end

  depends_on xcode: :build

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "build-mac/libetpan.xcodeproj",
               "-scheme", "static libetpan",
               "-configuration", "Release",
               "SYMROOT=build/libetpan",
               "build"

    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "build-mac/libetpan.xcodeproj",
               "-scheme", "libetpan",
               "-configuration", "Release",
               "SYMROOT=build/libetpan",
               "build"

    lib.install "build-mac/build/libetpan/Release/libetpan.a"
    frameworks.install "build-mac/build/libetpan/Release/libetpan.framework"
    include.install buildpath.glob("build-mac/build/libetpan/Release/include/**")
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
