class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.27.tar.xz"
  sha256 "51e53e58fc8158e5986a1f1a49a6d970c5b16493841cf7b9de2c2bde7ce36b93"

  bottle do
    cellar :any
    sha256 "6e9283bf3a50c68724965b8abbf7ee1084d3e086bb50d96af7ee5fca420a078c" => :sierra
    sha256 "6ce6a66ae7ff4321144f66e02f6d71be139336ea5256fd28d0d78be2188eee29" => :el_capitan
    sha256 "39aec42200bf5957c7b8d6c1c4357c9397eddd82f0df7b7acb36f146734c3b3f" => :yosemite
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
