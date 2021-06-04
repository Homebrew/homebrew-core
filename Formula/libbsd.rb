class Libbsd < Formula
  desc "Utility functions from BSD systems"
  homepage "https://libbsd.freedesktop.org/"
  url "https://libbsd.freedesktop.org/releases/libbsd-0.11.3.tar.xz"
  sha256 "ff95cf8184151dacae4247832f8d4ea8800fa127dbd15033ecfe839f285b42a1"
  license "BSD-3-Clause"

  depends_on "libmd"
  depends_on :linux

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "strtonum", shell_output("nm #{lib/"libbsd.so"}")
  end
end
