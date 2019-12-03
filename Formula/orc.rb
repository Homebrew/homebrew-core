class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.31.tar.xz"
  sha256 "a0ab5f10a6a9ae7c3a6b4218246564c3bf00d657cbdf587e6d34ec3ef0616075"

  bottle do
    cellar :any
    sha256 "9509aa50e56e4cb34e5852fe69a1137cf231ef1b0f3412e0f6af7cb6af69c97a" => :catalina
    sha256 "d2f7fdd730740d23c0a3da22b3fac412b68974a0e6c4cc1f5b55abf8f075d374" => :mojave
    sha256 "a04f6a05f82c5dc8ba526992d294fccb9d3e1206fd21e9e870f04f226f88f86e" => :high_sierra
    sha256 "9a84e0cc0f7268c805ab3440302e40f5b4c44f48f47b284e23c75f1e7014c206" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", "--prefix=#{prefix}", "-Dgtk_doc=disabled", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/orcc", "--version"
  end
end
