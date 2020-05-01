class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://cgit.freedesktop.org/gstreamer/orc/"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.31.tar.xz"
  sha256 "a0ab5f10a6a9ae7c3a6b4218246564c3bf00d657cbdf587e6d34ec3ef0616075"

  bottle do
    cellar :any
    sha256 "c4a11fbf1e2d645b0bbcbabc467c6f7fe604282833ece90264b063806a1e4909" => :catalina
    sha256 "b9c58730d763ca611867504ff7005245e95ca435b027d85ff7f7471dc7431b59" => :mojave
    sha256 "b732bc9e7fa9825222b0dda3dfdbe7f38cf45aeb46c239f432fc646d98079e76" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    mkdir "build" do
      system "meson", *std_meson_args, "-Dgtk_doc=disabled", ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{bin}/orcc", "--version"
  end
end
