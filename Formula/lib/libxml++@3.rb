class LibxmlxxAT3 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://download.gnome.org/sources/libxml++/3.2/libxml++-3.2.4.tar.xz"
  sha256 "ba53f5eaca45b79f4ec1b3b28bc8136fce26873cd38f2e381d9355289e432405"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "e7c499c2375d9bfa937a174a21f9d8fba1b4743fcac3a2f8186afa77c519720f"
    sha256 cellar: :any, arm64_ventura:  "27afebe6ebb966654ea6ca39e5feaa916bbdc2435554e32f4fb7ddf53404c75e"
    sha256 cellar: :any, arm64_monterey: "b84c0eaae133a13db2e06a2ff5902a0982ae26a3e4b5c543003b6df39cb94e3c"
    sha256 cellar: :any, sonoma:         "9d1bdc8411b1a55fc16a3676dd732f6f372f2f69e333d73ede91cdb7b51caabe"
    sha256 cellar: :any, ventura:        "8b8802982bd457546e8a9607c5001148eb356b09d2569ae3ff23593f2378411f"
    sha256 cellar: :any, monterey:       "4e8d9e3fc7d3d3b9e72cf7950ee1b5a15788334ac74f69f9eba554f2fca7fb8c"
    sha256               x86_64_linux:   "05572d1751f44129df78f110d24a2385c10f16d1a218d73be53cbbd3841581b1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glibmm@2.66"

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
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
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-3.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
