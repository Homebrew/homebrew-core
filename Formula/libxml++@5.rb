class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/5.0/libxml++-5.0.0.tar.xz"
  sha256 "3d716f522d380ba3a78458d8994cb1ce2b618f6a2026bce63ca5c86baef3b874"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any
    sha256 "8697b990d62b29042b6069511565b2bc747cb59e691e731648e4008f7b8456ec" => :big_sur
    sha256 "51de5f7cf3c4d7862e3cf63b887b16380a19e714f4d4b7740cf5f8592b695d0e" => :arm64_big_sur
    sha256 "bcab4e7bccfe864a6d5aa76583016cfa2a52d9c9ba9686c84a44581a85534f86" => :catalina
    sha256 "0fd223ce92fb3a1ffc9f5923506badfbf989656afaca2ca8a10d507e4733aa60" => :mojave
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.9" => :build

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
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-5.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
