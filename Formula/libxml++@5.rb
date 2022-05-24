class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.io/"
  url "https://download.gnome.org/sources/libxml++/5.0/libxml++-5.0.1.tar.xz"
  sha256 "15c38307a964fa6199f4da6683a599eb7e63cc89198545b36349b87cf9aa0098"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_monterey: "cdae1a5b5a898578afa753d6fb3fbafa413d07fbf2d8367ae3559dbd0eb9b066"
    sha256 cellar: :any, arm64_big_sur:  "04df228902b1127ce69db14966e48302294c8c903ac0cad3ba7d43d8af123855"
    sha256 cellar: :any, monterey:       "782cb6730ec7ea3dc20055d0addc043b014188926a5a7f6d6eaef521cb10fb06"
    sha256 cellar: :any, big_sur:        "a97fc98cc632deba48754e35a3ef6a065b720ebd24c93aa5b4e9f490e54f956f"
    sha256 cellar: :any, catalina:       "29587d375cdc89d559f90a4dcbe1dab535869dd5e3a04847f3fce23b831c2bac"
    sha256               x86_64_linux:   "c5e82519eaedf123b7d33e71a7ea7d36b5d44b730ee88189cd1f1055faa4ab33"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.10" => :build

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
