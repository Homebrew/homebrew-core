class Appledoc < Formula
  desc "Objective-C API documentation generator"
  homepage "http://appledoc.gentlebytes.com/"
  url "https://github.com/tomaz/appledoc/archive/2.2.1.tar.gz"
  sha256 "0ec881f667dfe70d565b7f1328e9ad4eebc8699ee6dcd381f3bd0ccbf35c0337"
  license "Apache-2.0"
  head "https://github.com/tomaz/appledoc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 3
    sha256 big_sur:  "a44c317d4c80798c24e3c9b72b622dd037e3c73f47c21e8fce200958322e14f6"
    sha256 catalina: "d4808573e4dd15de060e90374e77e43b1df1926cad45bec5331381d7dff1d1f3"
    sha256 mojave:   "a2530c73cfaa02a2a40be2b823d8c2115ce5fe8d0a59c765829aad55bf3e7c33"
  end

  # Includes prebuild Library/*.a files (Intel-only)
  # so it does not build fully from source
  disable! date: "2020-12-31", because: :does_not_build

  depends_on xcode: :build
  depends_on arch: :x86_64
  depends_on :macos

  def install
    xcodebuild "-project", "appledoc.xcodeproj",
               "-target", "appledoc",
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
