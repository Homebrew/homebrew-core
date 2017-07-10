class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.tar.gz"
  sha256 "8cc7b03ceb2722223a6457e95d4c994731d80214a03ba33d1af76ba53f4b3197"

  bottle do
    cellar :any
    sha256 "ec05352ba412fb64cda82e4a964b9a0e6e625481a3d5b13a66db8be9d39d29f6" => :sierra
    sha256 "eb799e6822088371803fb833a44099cb1ab54ab1b775da3c858b85db963be411" => :el_capitan
    sha256 "1d3c4c9b4848d88a29d16702ab1d3e9cca5d2e801cf99886d9b13b38510f09ef" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert File.exist?("test.m4a")
  end
end
