class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.5.tar.gz"
  sha256 "53207f479f96c4f792b3187f31abf3534d69c88fe23720d0c23f5310c5d2b2f5"
  head "https://github.com/tjko/jpegoptim.git"

  bottle do
    cellar :any
    sha256 "18497db72a6a4e66f04c02b186a16f788682a63df6181044ad5467f8316616e5" => :high_sierra
    sha256 "384f4eea9c9f0b53526f2da9955f61644a29bdab54bbc23cd70537727be22d2e" => :sierra
    sha256 "e8b13a1688e86078cab8e632fff53d962358df9bf8e3a60260dcc043065e3e03" => :el_capitan
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
