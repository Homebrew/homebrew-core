class Apng2gif < Formula
  desc "Convert APNG animations into animated GIF format"
  homepage "https://apng2gif.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/apng2gif/1.8/apng2gif-1.8-src.zip"
  sha256 "9a07e386017dc696573cd7bc7b46b2575c06da0bc68c3c4f1c24a4b39cdedd4d"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "96885dd78971006a1a9c2110cf491436d16cb705fd29c67a8506c06c41cf867c"
    sha256 cellar: :any,                 arm64_monterey: "06feb5f45bd0926a23bcda94caf5af7eb1f29166b71853ea3c9136c74c63d000"
    sha256 cellar: :any,                 arm64_big_sur:  "b11d6a2f6d1eba7587c8541f65440b027596ae8b3b60ea23e080a237d0b215a3"
    sha256 cellar: :any,                 ventura:        "f67f54a6e9f79ca11e7d1c0f5b9d4fbbf43ed6f4b0045875287ad4dafb5df70d"
    sha256 cellar: :any,                 monterey:       "58b5118280140555684d30a9682450f95ddcbbb7f2f03d6a354da850b3f432db"
    sha256 cellar: :any,                 big_sur:        "8c541ad0b322c10bacc60230d91daf242f3b7ebb8e5deb72860fe2dc1b8cb551"
    sha256 cellar: :any,                 catalina:       "e602a9876003067007cdd579101e1fafa937e7a2ca328a0406e872d6be4f5705"
    sha256 cellar: :any,                 mojave:         "f0f18d7ae3beaaac092bc06bccc3f5fdcd0c7de11df6ded61e8fde151d3e2276"
    sha256 cellar: :any,                 high_sierra:    "810005bcbc32c60c7084b248eef3d007e756180842051f64385fb90cfac66c63"
    sha256 cellar: :any,                 sierra:         "fa18274f18fb0d3a2b3f5c360c24587b805db3f4734972c350643c35b8677174"
    sha256 cellar: :any,                 el_capitan:     "42d033ae0a661d75b588af8d7c0cdb67a81bfc481aa88665973d95d3e4fb64ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f98dfacc9457ddd5742ff27448fdd3b51dbd1445a586447327404bcb0028b72a"
  end

  depends_on "libpng"

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
