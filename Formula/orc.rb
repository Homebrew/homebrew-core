class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.26.tar.xz"
  sha256 "7d52fa80ef84988359c3434e1eea302d077a08987abdde6905678ebcad4fa649"

  bottle do
    cellar :any
    sha256 "74f9286ad20ccad5fcb2f855bd2d855b6709fa5a2f804928c710d3e3229d8087" => :el_capitan
    sha256 "fa8e5bd4d5899fd420a772025005ec8b25e3f446c01ec61a357d4edc64734aba" => :yosemite
    sha256 "6f998c310042780d4a8deccd9e3aae25362b7904932d45e4944d761f77bf1fe1" => :mavericks
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
