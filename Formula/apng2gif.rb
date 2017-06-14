class Apng2gif < Formula
  desc "Convert APNG animations into animated GIF format."
  homepage "https://apng2gif.sourceforge.io/"
  url "https://downloads.sourceforge.net/apng2gif/apng2gif-1.8-src.zip"
  sha256 "9a07e386017dc696573cd7bc7b46b2575c06da0bc68c3c4f1c24a4b39cdedd4d"

  depends_on "libpng"

  fails_with :clang if MacOS.version <= :yosemite

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
