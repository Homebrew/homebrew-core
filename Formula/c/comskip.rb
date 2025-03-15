class Comskip < Formula
  desc "Free commercial detector"
  homepage "https://www.comskip.org"
  url "https://github.com/erikkaashoek/Comskip/archive/refs/tags/V0.83.tar.gz"
  sha256 "bd90d7922916e0b04ea9f3426ea7747d347f218f3f915fb4d251961d0730876e"
  license "GPL-2.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "argtable"
  depends_on "ffmpeg"
  depends_on "sdl2"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    video = test_fixtures("test.gif")
    shell_output("#{bin}/comskip #{video} --output #{testpath}", 1)
    assert_path_exists testpath/"test.txt"

    assert_match "Comskip #{version}", shell_output("#{bin}/comskip --help 2>&1", 2)
  end
end
