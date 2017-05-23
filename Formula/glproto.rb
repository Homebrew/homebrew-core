class Glproto < Formula
  desc "X11 OpenGL extension wire protocol"
  homepage "https://wiki.freedesktop.org/xorg"
  url "https://www.x.org/releases/individual/proto/glproto-1.4.17.tar.bz2"
  sha256 "adaa94bded310a2bfcbb9deb4d751d965fcfe6fb3a2f6d242e2df2d6589dbe40"

  depends_on :x11
  depends_on "pkg-config" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
