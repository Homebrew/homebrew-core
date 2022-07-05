class MypaintBrushes < Formula
  desc "Brushes used by MyPaint and other software using libmypaint"
  homepage "https://github.com/mypaint/mypaint-brushes"
  url "https://github.com/mypaint/mypaint-brushes/archive/v1.3.0.tar.gz"
  sha256 "704bb6420e65085acfd7a61d6050e96b0395c5eab078433f11406c355f16b214"
  license "CC0-1.0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "libmypaint"

  def install
    ENV["ACLOCAL"] = "aclocal"
    ENV["AUTOMAKE"] = "automake"

    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_predicate share.glob("mypaint-data/*/brushes/classic/marker_small_prev.png").first, :exist?
  end
end
