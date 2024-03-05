class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://download.gnome.org/sources/libxml++/5.2/libxml++-5.2.0.tar.xz"
  sha256 "e41b8eae55210511585ae638615f00db7f982c0edea94699865f582daf03b44f"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "682c427814f5cf041d88f80df70413978bcfdf54e87b402c971199c707a86b2e"
    sha256 cellar: :any,                 arm64_ventura:  "be487d7fde818a30c0024a729cee52144b7e07a6611cbc2b5f252afa1f25586d"
    sha256 cellar: :any,                 arm64_monterey: "d210f4920daa0b562c25423a47d4f02ddd90ba13c79ef50f57228f4f6808aea3"
    sha256 cellar: :any,                 sonoma:         "3735d367bb98aade3530e2e7cb6d8dc5a574fad0209bb9648096522effd43e30"
    sha256 cellar: :any,                 ventura:        "e9393ece09c9e6a22b772cc5f2372f6491b3e27d6e47e1c869db3325af73fa30"
    sha256 cellar: :any,                 monterey:       "eef6ef1f94bfa796766633ef91840ded6319ff56b6a81f1d0312679861da7b62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9476f20000685eb9c8db5bc4d762ca47a462a3a39d5f0711cbec7b071617d0b8"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

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
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-5.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
