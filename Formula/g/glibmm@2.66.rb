class GlibmmAT266 < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.7.tar.xz"
  sha256 "fe02c1e5f5825940d82b56b6ec31a12c06c05c1583cfe62f934d0763e1e542b3"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.66/"
    regex(/href=.*?glibmm[._-]v?(2\.66(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1466172346191c3cf8989fd4bed922ad0bf8ef0b00395b1dd005f1cf6f27db50"
    sha256 cellar: :any, arm64_ventura:  "9fa6fe82b00364519f11c54063f12cd9bd2f502a92d8a7562292a11e28e445fe"
    sha256 cellar: :any, arm64_monterey: "8ade0f784ae08c3a84a6fb594039066598fc3c653a096e431a37c03151116d7b"
    sha256 cellar: :any, sonoma:         "0b33fc5295ae68bed483e2719b3ab0e92abcecb8c4a2a52368b45a3608c7dfee"
    sha256 cellar: :any, ventura:        "1742adfa35be37169c4c5ee0ae6b37815fe4e7de541a07fd5c36dddbf44910d6"
    sha256 cellar: :any, monterey:       "1c8f922d8b1b0bb3298fffd5fbb59c308ae9fa375cc0eaf0b0cc7b4150f46568"
    sha256               x86_64_linux:   "e73a3eb58812790f1057663483cb3047cb1c33f80497faa11393ddf8e411c20b"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++@2"

  def install
    system "meson", "setup", "build", *std_meson_args
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

    flags = shell_output("pkg-config --cflags --libs glibmm-2.4").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
