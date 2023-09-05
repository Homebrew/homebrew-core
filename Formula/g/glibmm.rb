class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.76/glibmm-2.76.0.tar.xz"
  sha256 "8637d80ceabd94fddd6e48970a082a264558d4ab82684e15ffc87e7ef3462ab2"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "efb2d63014192cb076d4972e352dc235bf61030e7be0fb261cccc90f2f183013"
    sha256 cellar: :any, arm64_monterey: "96edf336fd9654f9e659370c388d5956ed3da540ae5f88f17aa9d825c5073876"
    sha256 cellar: :any, arm64_big_sur:  "cad2efd82f0fd07269fc25e7299730bffa7d29f5132dfa8cb214524fcf33f20c"
    sha256 cellar: :any, ventura:        "337a1116c3310f4d7d5b26a462f5c115cb1fa08bfb0224ae49f856cf7a88ac08"
    sha256 cellar: :any, monterey:       "5e71daf9c7ad6aaf1b6cd644e8bd27c54081a12ff3daec41a19e57f424f491bd"
    sha256 cellar: :any, big_sur:        "db053d1bb27ec96c72cd75e10f7365e340115d00d1a89df9cf9f2ed3d01c56fd"
    sha256               x86_64_linux:   "b3ebeaa7cf7b0491e47ee2315792e863b4e8f8d8b101793d5cab4c1a0fcb97a0"
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
