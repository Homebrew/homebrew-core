class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.28.tar.xz"
  sha256 "bfcd7c6563b05672386c4eedfc4c0d4a0a12b4b4775b74ec6deb88fc2bcd83ce"

  bottle do
    cellar :any
    sha256 "0d14acdd8539f1aaf104c8e72a0cde4e7d163afb9d5afb58df3a04babd0094aa" => :high_sierra
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
