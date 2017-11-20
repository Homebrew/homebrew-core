class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.28.tar.xz"
  sha256 "bfcd7c6563b05672386c4eedfc4c0d4a0a12b4b4775b74ec6deb88fc2bcd83ce"

  bottle do
    cellar :any
    sha256 "bc08fab45dc2650b71950bff090bb09e64595778f3810bca442775b7973a43dd" => :high_sierra
    sha256 "6eafe23ac5c17b765ca6f59eb65c52d782d2858bbca7a4f374b77258dedb828f" => :sierra
    sha256 "c640dd001774b981101cbc223c51e31aafb35a6b8bc2e2fc3fc2c15dbfe3fbae" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-gtk-doc"
    system "make", "install"
  end

  test do
    system "#{bin}/orcc", "--version"
  end
end
