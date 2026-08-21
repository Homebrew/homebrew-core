class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://gtkmm.gnome.org/"
  url "https://download.gnome.org/sources/glibmm/2.88/glibmm-2.88.1.tar.xz"
  sha256 "c139f962b1575c8827cd39d1ac21b7a367be3bda1409c0c7e21a29090f371506"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1820b1d736061b49c2b659e70809dcc79acdc47d5229d58ec19fcf9081565d70"
    sha256 cellar: :any, arm64_sequoia: "8123fe33bb48afcc1518f58f2d8f5d5432b34efa17bd47bcf12bc1849a00070d"
    sha256 cellar: :any, arm64_sonoma:  "75665105fafb18f9b5b057cac75f853da291e2597d802f71fe5fc090a231a7bf"
    sha256 cellar: :any, sonoma:        "72600139d4fec0a5a4a560cf5f677aa2d63b00e53ecc430baa9796a53d758a19"
    sha256               arm64_linux:   "021fe24e5650a79bd327a012cccf84fd853d358e548ea135215fc1c346267f51"
    sha256               x86_64_linux:  "1e8eee26d278df95a8a7b9a859bf2ed42319b2599c80dfc811d881fcf6f9d809"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++"

  def install
    system "meson", "setup", "build", "-Dbuild-examples=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    CPP
    flags = shell_output("pkgconf --cflags --libs glibmm-2.68").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
