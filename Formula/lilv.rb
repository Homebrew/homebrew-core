class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv/"
  url "https://download.drobilla.net/lilv-0.24.8.tar.bz2"
  sha256 "cadc3654c481aec6a6db504439cf8c0572c06128a6fbca1953a30df77e89c300"
  license "ISC"

  bottle do
    cellar :any
    sha256 "b772a0b962e14b7ae737f3bdf5778b34092e86eeca19e2c520395777b87be9cd" => :catalina
    sha256 "01c5b495e5c288e19a325164f482cc3058865b118f2d5c05a52e44db5deec302" => :mojave
    sha256 "63c518910af136ca8b4f685924ccd3e6f2687cd061cd561c4aab69af7fa62361" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
