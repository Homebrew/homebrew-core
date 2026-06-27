class Atkmm < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.36/atkmm-2.36.4.tar.xz"
  sha256 "19cd0758ed752cb89f5bf02247663dfad0926d9351984a20e3c6cf7da62552ac"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7ddb83b502756b3e2e066918173a8bd07b2e3a3b2a2716832bdd7fe9f6d3c4c8"
    sha256 cellar: :any, arm64_sequoia: "913a93e6e25e13412b80bacd1839a6bc84f0a4d863982b9d1d5a8d678b1872f5"
    sha256 cellar: :any, arm64_sonoma:  "09c4416ad6a1a564e44020ac7105a62c5f039ec26d0c07c1884e235873e66775"
    sha256 cellar: :any, sonoma:        "bae2a1c6ab7b9741edcd6e7f18477fadfcd20a171edf229206eeccc8485b1947"
    sha256               arm64_linux:   "84c62a27f52f7204fad25e2abbbe448d02b676fd1d328bb4ffe813afffd5e307"
    sha256               x86_64_linux:  "ec7b0fe0825b753c73c3864de6df4e7dc4b0107e2a5c193eeb4e601f258b918c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "at-spi2-core"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "libsigc++"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <atkmm/init.h>

      int main(int argc, char *argv[])
      {
         Atk::init();
         return 0;
      }
    CPP
    flags = shell_output("pkg-config --cflags --libs atkmm-2.36").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
