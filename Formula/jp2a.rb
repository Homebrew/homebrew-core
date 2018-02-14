class Jp2a < Formula
  desc "Convert JPG images to ASCII"
  homepage "https://csl.name/jp2a/"
  url "https://downloads.sourceforge.net/project/jp2a/jp2a/1.0.6/jp2a-1.0.6.tar.gz"
  sha256 "0930ac8a9545c8a8a65dd30ff80b1ae0d3b603f2ef83b04226da0475c7ccce1c"
  revision 1

  bottle do
    cellar :any
    sha256 "c68f18d28eb4799c5aa6a74c5f2c98a21b9c0968ed2cd9af6b4ea16a7f206fa6" => :high_sierra
    sha256 "2d5c4358454d3fa29f6bf4ebb9f43992f7fd0fd68f9161476ae2cd79f51a652a" => :sierra
    sha256 "ff1455c705893442d357efb79b275c6337b24a9e11c959e38f06df5cde4367ae" => :el_capitan
    sha256 "2a175fef16afed3e74c834ff250f0278eedc60c4deb0296e62f073954605d97d" => :yosemite
  end

  option "without-test", "Skip compile-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    system bin/"jp2a", test_fixtures("test.jpg")
  end
end
