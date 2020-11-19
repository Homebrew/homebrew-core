class Libbsd < Formula
  desc "Utility functions from BSD systems"
  homepage "https://libbsd.freedesktop.org/"
  url "https://libbsd.freedesktop.org/releases/libbsd-0.10.0.tar.xz"
  sha256 "34b8adc726883d0e85b3118fa13605e179a62b31ba51f676136ecb2d0bc1a887"
  license "BSD-3-Clause"

  depends_on :linux

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "strtonum", shell_output("nm #{lib/"libbsd.so"}")
  end
end
