class Apng2gif < Formula
  desc "Convert APNG animations into animated GIF format"
  homepage "https://apng2gif.sourceforge.io/"
  url "https://downloads.sourceforge.net/apng2gif/apng2gif-1.8-src.zip"
  sha256 "9a07e386017dc696573cd7bc7b46b2575c06da0bc68c3c4f1c24a4b39cdedd4d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e602a9876003067007cdd579101e1fafa937e7a2ca328a0406e872d6be4f5705" => :catalina
    sha256 "f0f18d7ae3beaaac092bc06bccc3f5fdcd0c7de11df6ded61e8fde151d3e2276" => :mojave
    sha256 "810005bcbc32c60c7084b248eef3d007e756180842051f64385fb90cfac66c63" => :high_sierra
    sha256 "fa18274f18fb0d3a2b3f5c360c24587b805db3f4734972c350643c35b8677174" => :sierra
    sha256 "42d033ae0a661d75b588af8d7c0cdb67a81bfc481aa88665973d95d3e4fb64ec" => :el_capitan
    sha256 "5456ec2b90086c84f2094972fa0dacc11de0abdde5346e3445a6b7d64b49201c" => :yosemite
  end

  depends_on "libpng"

  if MacOS.version <= :yosemite
    depends_on "gcc"
    fails_with :clang
  end

  def install
    system "make"
    bin.install "apng2gif"
  end

  test do
    cp test_fixtures("test.png"), testpath/"test.png"
    system bin/"apng2gif", testpath/"test.png"
    assert_predicate testpath/"test.gif", :exist?, "Failed to create test.gif"
  end
end
