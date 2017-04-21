class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv/"
  url "https://download.drobilla.net/lilv-0.24.0.tar.bz2"
  sha256 "fa60de536d3648aa3b1a445261fd77bd80d0246a071eed2e7ca51ea91a27fb9e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "65ae432ffc7b608b80346984640c9afcf4ab94fdbfa9e354759d7232680f97a8" => :sierra
    sha256 "bdece8afbd612253dc269a2259d01ab99c27c6383c8244bc27e4da7e5a5ce2e4" => :el_capitan
    sha256 "d5310728dc038ea81fb298bdc740d11ecba02a917f1f54472459539cf8b2f54d" => :yosemite
    sha256 "0cc10d77bb89587c07f3f23ddbed630a861ecc73f1da8efa9b36958a04406964" => :mavericks
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

  test do
    lv2info = shell_output("#{bin}/lv2info --version")
    assert_equal lv2info.lines.first, "lv2info (lilv) 0.24.0"
  end
end
