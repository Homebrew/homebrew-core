class Appledoc < Formula
  desc "Objective-C API documentation generator"
  homepage "http://appledoc.gentlebytes.com/"
  url "https://github.com/tomaz/appledoc/archive/2.2.1.tar.gz"
  sha256 "0ec881f667dfe70d565b7f1328e9ad4eebc8699ee6dcd381f3bd0ccbf35c0337"
  license "Apache-2.0"
  head "https://github.com/tomaz/appledoc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 "e182316143290aa24b778b57c4f2fa15b66039af0d94840de0d99836f92e7926" => :big_sur
    sha256 "2fbc0125b9cbe625b5ec657f4e0e2a83ff368418c526f9770a202bccc87d1524" => :catalina
    sha256 "b2728220ad4932d681eb7151f0629ebd32b9ed6dd149648575707f7cdd2e4b71" => :mojave
  end

  depends_on xcode: :build
  depends_on arch: :x86_64
  depends_on :macos

  def install
    xcodebuild "-project", "appledoc.xcodeproj",
               "-target", "appledoc",
               # The 2.2.1 tarball includes prebuild Library/*.a files which only
               # are built for intel:
               "-arch", "x86_64",
               "-configuration", "Release",
               "clean", "install",
               "SYMROOT=build",
               "DSTROOT=build",
               "INSTALL_PATH=/bin",
               "OTHER_CFLAGS='-DCOMPILE_TIME_DEFAULT_TEMPLATE_PATH=@\"#{prefix}/Templates\"'"
    bin.install "build/bin/appledoc"
    prefix.install "Templates/"
  end

  test do
    (testpath/"test.h").write <<~EOS
      /**
       * This is a test class. It does stuff.
       *
       * Here **is** some `markdown`.
       */

      @interface X : Y

      /**
       * Does a thing.
       *
       * @returns An instance of X.
       * @param thing The thing to copy.
       */
      + (X *)thingWithThing:(X *)thing;

      @end
    EOS

    system bin/"appledoc", "--project-name", "Test",
                           "--project-company", "Homebrew",
                           "--create-html",
                           # docset tools were removed in Xcode 9.3:
                           #   https://github.com/tomaz/appledoc/issues/628
                           # ...so --no-create-docset is essentially required
                           "--no-create-docset",
                           "--keep-intermediate-files",
                           "--output", testpath,
                           testpath/"test.h"
  end
end
