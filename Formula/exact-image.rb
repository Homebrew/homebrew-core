class ExactImage < Formula
  desc "Image processing library"
  homepage "https://exactcode.com/opensource/exactimage/"
  url "https://dl.exactcode.de/oss/exact-image/exact-image-1.0.1.tar.bz2"
  sha256 "3bf45d21e653f6a4664147eb4ba29178295d530400d5e16a2ab19ac79f62b76c"

  bottle do
    sha256 "ad9a08346cef8389013aaba11d374b70e4eee239e9d57b7c71485eed1cda838f" => :high_sierra
    sha256 "2dd2e178792d741119e2bb81a138f41ee89fbcfaf41ed0c46e8f81eaeb46e42c" => :sierra
    sha256 "7f437345feae9532b1313bb331eed57ce7a6cd4cbfca2c42aadba6204206744c" => :el_capitan
    sha256 "e259695a00a3962871e6b5030d579836d4f64e28daead6f297faf7783edd17af" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libagg"
  depends_on "freetype" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/bardecode"
  end
end
