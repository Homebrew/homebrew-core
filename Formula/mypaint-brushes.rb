class MypaintBrushes < Formula
  desc "Brushes used by MyPaint and other software using libmypaint"
  homepage "https://github.com/mypaint/mypaint-brushes"
  url "https://github.com/mypaint/mypaint-brushes/archive/v2.0.2.tar.gz"
  sha256 "01032550dd817bb0f8e85d83a632ed2e50bc16e0735630839e6c508f02f800ac"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ea16090070ac3b74d22f1bf9a4fd67087603bb9157785add7af285b1d439281e"
  end

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
