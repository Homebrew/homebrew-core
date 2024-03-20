class GlibmmAT266 < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.6.tar.xz"
  sha256 "5358742598181e5351d7bf8da072bf93e6dd5f178d27640d4e462bc8f14e152f"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.66/"
    regex(/href=.*?glibmm[._-]v?(2\.66(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "37f2bab6f8512cf758144d7fe1e75e8cac88c03a1aca6671721b3577140e9f03"
    sha256 cellar: :any, arm64_ventura:  "187891e655f142a36604b95c20ee03c4121c7f1bb9b18b946e5ab6393c34473d"
    sha256 cellar: :any, arm64_monterey: "1fea23c1f77f054c4c2aa2af28f790f9925009fb881e19c5919ee020bc97d276"
    sha256 cellar: :any, sonoma:         "b2bc09369516ea9a4d73488ec55a6951da1b8f45338d80560a002203dd4636de"
    sha256 cellar: :any, ventura:        "ca2a492586ee5d0d9e48deac89d5838fa4e6d856daf08b3a413f6ec91069c179"
    sha256 cellar: :any, monterey:       "5d319a089e7ce4da73188ce4e0652a4ca14b3a756ec6c56c69b30015985c011b"
    sha256               x86_64_linux:   "828d91142a3af237d14d2c964b442d2317943cb451417dab556f4e1c938390bf"
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
