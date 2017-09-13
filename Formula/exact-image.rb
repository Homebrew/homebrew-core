class ExactImage < Formula
  desc "Image processing library"
  homepage "https://exactcode.com/opensource/exactimage/"
  url "https://dl.exactcode.de/oss/exact-image/exact-image-0.9.2.tar.bz2"
  sha256 "665b205740b17b4162fae73aa36eb7046f28bb216d612461ca0499ff47a566ba"

  bottle do
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
