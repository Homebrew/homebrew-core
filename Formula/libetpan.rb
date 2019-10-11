class Libetpan < Formula
  desc "Portable mail library handling several protocols"
  homepage "https://www.etpan.org/libetpan.html"
  url "https://github.com/dinhviethoa/libetpan/archive/1.9.3.tar.gz"
  sha256 "591f97d5102f600e668502fe1dd5a341e910a840d8ea62e689a3a79d8bfbac87"
  head "https://github.com/dinhviethoa/libetpan.git", :branch => "master"

  bottle do
    cellar :any
    sha256 "4f9b9ec25e82d190b2f1b488a8309918eb387d92c1112c72affb1d9a2e8bed41" => :catalina
    sha256 "f9c8629d0d2282ffa40ab63cb18efafc8f1eced93fa34330c23c8a5aa7077e1b" => :mojave
    sha256 "1c987f8bcdd60768be72e0b724050a6d518f472e6cd10f15a31898415ff2f254" => :high_sierra
    sha256 "9bc63c0c6302a29e1fe513d179029fe9d70984b043e0940c31073c114fd09199" => :sierra
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
