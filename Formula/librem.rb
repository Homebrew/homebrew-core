class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/rem-0.6.0.tar.gz"
  sha256 "417620da3986461598aef327c782db87ec3dd02c534701e68f4c255e54e5272c"

  bottle do
    cellar :any
    sha256 "2cf0be5b7be4a249bbadeb9888831b846d91e86a2a54f0932dd1d4ef2389e5b4" => :mojave
    sha256 "176dde5c993f519d96ba01353c834656967e1d3e1aad45ac42a94876ad70fa64" => :high_sierra
    sha256 "b2858cd7240e339c5a475b100a6ea1218458288a9e5a12f2fb5e00cb1b3a1e02" => :sierra
    sha256 "a5d1f8bedf157664f7f5c2cff9c5845d3e802cde6e6e6b6a2d91b1736bc01e28" => :el_capitan
  end

  depends_on "libre"

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return (NULL != vidfmt_name(VID_FMT_YUV420P)) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-lrem", "-o", "test"
    system "./test"
  end
end
