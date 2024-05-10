class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.80/glibmm-2.80.0.tar.xz"
  sha256 "539b0a29e15a96676c4f0594541250566c5ca44da5d4d87a3732fa2d07909e4a"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "8146911c8de1e567e11c9125e200d980aa8fcc949670be77f005337fc13d1539"
    sha256 cellar: :any, arm64_ventura:  "80d92647ef150c09cb50379b97a7ff74ce525266a9d43b0b72d094642c688d0a"
    sha256 cellar: :any, arm64_monterey: "a59f817889d8bff3abe041194aa52717d28e9429e069005e8f92d57805fe0db1"
    sha256 cellar: :any, sonoma:         "349305c1bf11e5833b7288e1898f63ea520bb259eec32a957fceda0a59b60186"
    sha256 cellar: :any, ventura:        "6ec8c02168f12f069a8d75cfa6f81af8fd906b1ffb1f8678a865b6879adc28c4"
    sha256 cellar: :any, monterey:       "9bfc78450bef875c2a85fc9ca85f6036914a4d56ba9fcd0139404f5308c14c97"
    sha256               x86_64_linux:   "dfa186baebe5dca5af93f3ca2799e34ad128efedc6183bdad0f3e73bbdf41acd"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", "-Dbuild-examples=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs glibmm-2.68").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
