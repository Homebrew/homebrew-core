class Apng2gif < Formula
  desc "Convert APNG animations into animated GIF format."
  homepage "https://apng2gif.sourceforge.io/"
  url "https://downloads.sourceforge.net/apng2gif/apng2gif-1.8-src.zip"
  sha256 "9a07e386017dc696573cd7bc7b46b2575c06da0bc68c3c4f1c24a4b39cdedd4d"

  bottle do
    cellar :any
    sha256 "95ff574aa91e45f9307fbc85c9857dac0b2d336c21233c7f6970784b3a2fd5c4" => :sierra
    sha256 "0abea0f7a478393d23239ccab82f30d47d4e64fd7de2729d30cb29ae09abfdaf" => :el_capitan
    sha256 "fc67179e48b935a0dc6af4dd83b09c9a723ed350b469517ccd1b80b1566ba29a" => :yosemite
  end

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
