class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.27.tar.xz"
  sha256 "51e53e58fc8158e5986a1f1a49a6d970c5b16493841cf7b9de2c2bde7ce36b93"

  bottle do
    cellar :any
    sha256 "28ec9859fb45bf2325a871ae04aabc2e52bdcd996424f5bbe4f116542947ca7a" => :sierra
    sha256 "898aab2c8b3130b7ba114ab9aef396da0dbd2360477dccb74d96825e16feed83" => :el_capitan
    sha256 "1c673f9ecf72830b030dcac2035949a598b036bda3d15fd23ebf7c9643c9f330" => :yosemite
    sha256 "257b50ea85c8481edf1638bab17c027a191f2a492955cb214a23f5cd6516db56" => :mavericks
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
