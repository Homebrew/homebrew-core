class Appledoc < Formula
  desc "Objective-C API documentation generator"
  homepage "http://appledoc.gentlebytes.com/"
  url "https://github.com/tomaz/appledoc/archive/2.2.1.tar.gz"
  sha256 "0ec881f667dfe70d565b7f1328e9ad4eebc8699ee6dcd381f3bd0ccbf35c0337"
  head "https://github.com/tomaz/appledoc.git"

  bottle do
    rebuild 1
    sha256 "35ced2445cb6f9744a2b8ef09d1f5d504aefe4995a8463639bf4fa8b5271e5f8" => :catalina
    sha256 "dd27c7222d181acb351bf33921ef203fcafc4df3e06618ad99b16cf069dd646c" => :mojave
    sha256 "ccae984913f4bcd3c0ff8f9d527a3330445c432af0bf98da315edbea83ccd0a5" => :high_sierra
  end

  depends_on :xcode => :build

  def install
    xcodebuild "-project", "appledoc.xcodeproj",
               "-target", "appledoc",
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
                           "--no-install-docset",
                           "--keep-intermediate-files",
                           "--docset-install-path", testpath,
                           "--output", testpath,
                           testpath/"test.h"
  end
end
