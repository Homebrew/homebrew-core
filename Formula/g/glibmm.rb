class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.78/glibmm-2.78.1.tar.xz"
  sha256 "f473f2975d26c3409e112ed11ed36406fb3843fa975df575c22d4cb843085f61"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f83307531539a19cacebe0a9fa292bc335908ad8caa15f5e615bdcce006d1ac9"
    sha256 cellar: :any, arm64_ventura:  "657b75bb9dc8f49e32aa80a0223f7cbbbaa32c0f47e067474c7a5ae3ca6314fb"
    sha256 cellar: :any, arm64_monterey: "81df6b89b112dc0df48361cbc21ee3ec14ff2bfa2bd19759e72e1571669ebb78"
    sha256 cellar: :any, sonoma:         "ea2bca4d30436517689806bc5df8edc8d45c37ea0826a81a20672560fbfc3d78"
    sha256 cellar: :any, ventura:        "96fa56c126f7e27f6be30b833e95d57df854b50f017746d1503a27e70ba1d083"
    sha256 cellar: :any, monterey:       "dafa558d5a56ecce6b183b8c6e64d85a2176fa99e9a2a606c2311c4d002f836d"
    sha256               x86_64_linux:   "04316ee77bc16c00f5aebbf2d637061fb7963304592c164acb898f3ed6e480f0"
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
