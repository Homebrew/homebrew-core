class LibxmlxxAT4 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/4.0/libxml++-4.0.0.tar.xz"
  sha256 "4f26b5fdb9ebd91e440d60343ac82400f88287facedc7e81b95f23d002f8049f"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "fdbaba1cc15f335517a1cc504b89502870a41914bf1cb30b158becf3011d1ea3" => :big_sur
    sha256 "915b575a6d1d6c1cebf6399d94434fc448b2900a4b87260875a120f45deaa79d" => :arm64_big_sur
    sha256 "df3ff271d16a9f73bfab2039c3d8f33af73ae1c0cba4f5f936bfca3e4058b2a6" => :catalina
    sha256 "80e6dc79069c4e90b3c5c23e7a18dc580938e88b742c7ba0dcb67ffb538aa6aa" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glibmm"

  uses_from_macos "libxml2"

  def install
    ENV.cxx11
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-4.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
