class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://gtkmm.gnome.org/"
  url "https://download.gnome.org/sources/glibmm/2.86/glibmm-2.86.0.tar.xz"
  sha256 "39c0e9f6da046d679390774efdb9ad564436236736dc2f7825e614b2d4087826"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5f5d4eae7ddd8d562762a6b4b56889481248b30dd9a59d9118d94d2206ccb54f"
    sha256 cellar: :any, arm64_sequoia: "94f716bf3dd9147f90eea8291fd7956463121b1cb3843ef505c8068d42f9c662"
    sha256 cellar: :any, arm64_sonoma:  "0fa086e181357f65773cac6deffb15afaeae867d514af0e3858068220e3d60c5"
    sha256 cellar: :any, sonoma:        "b0e489bde8ce810195dcf79c4df085a3bf58fcfe34980314ac5ce47231bc3d02"
    sha256               arm64_linux:   "a705b9778941457209f0b31bf52095d9db3bc98e1defcdb04eecc23ba5036758"
    sha256               x86_64_linux:  "3e9231a310a6d60283b1ac9deb53f38ebd065f7ddca58ad284c5b662cf4da23e"
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
