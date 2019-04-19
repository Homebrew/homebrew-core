class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://csl.name/jp2a/"
  url "https://github.com/cslarsen/jp2a/archive/v1.0.7.tar.gz"
  sha256 "e509d8bbf9434afde5c342568b21d11831a61d9942ca8cb1633d4295b7bc5059"

  bottle do
    cellar :any
    sha256 "12a78b015bc8204f0c8375f06bf45fb71120d3b7b51ef9e695807e65b313143f" => :mojave
    sha256 "c68f18d28eb4799c5aa6a74c5f2c98a21b9c0968ed2cd9af6b4ea16a7f206fa6" => :high_sierra
    sha256 "2d5c4358454d3fa29f6bf4ebb9f43992f7fd0fd68f9161476ae2cd79f51a652a" => :sierra
    sha256 "ff1455c705893442d357efb79b275c6337b24a9e11c959e38f06df5cde4367ae" => :el_capitan
    sha256 "2a175fef16afed3e74c834ff250f0278eedc60c4deb0296e62f073954605d97d" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "jpeg"

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
