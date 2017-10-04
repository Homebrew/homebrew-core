class Gpsd < Formula
  desc "Global Positioning System (GPS) daemon"
  homepage "http://catb.org/gpsd/"
  url "https://download.savannah.gnu.org/releases/gpsd/gpsd-3.17.tar.gz"
  sha256 "68e0dbecfb5831997f8b3d6ba48aed812eb465d8c0089420ab68f9ce4d85e77a"

  bottle do
    cellar :any
    sha256 "89237ff11349f301e4a41a9f1d0ad7948f9a257d91a95be6ec6b4c9e26187f72" => :high_sierra
    sha256 "1a7912b32f3cc2d59d5d7b615ec3e8e2d14399d0256f2768b91be029f64e2438" => :sierra
    sha256 "6fb615b0aba85f6692cf6f8ac529ee8a2777d300bba6a9d8ff8abe90784d0fa5" => :el_capitan
  end

  depends_on "scons" => :build
  depends_on "libusb" => :optional

  def install
    system "2to3-", "--write", "--fix=print", "SConstruct"
    scons "chrpath=False", "python=False", "strip=False", "prefix=#{prefix}/"
    scons "install"
  end
end
