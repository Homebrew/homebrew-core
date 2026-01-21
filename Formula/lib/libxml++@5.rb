class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://github.com/libxmlplusplus/libxmlplusplus/releases/download/5.6.0/libxml++-5.6.0.tar.xz"
  sha256 "cd01ad15a5e44d5392c179ddf992891fb1ba94d33188d9198f9daf99e1bc4fec"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d8f7af5b6ae22cf7f4ebc0cdcc6ff4c8da8948fed395c9ec78f70c945af17ef1"
    sha256 cellar: :any, arm64_sequoia: "0de758278ded4db21000aef5e7e65ede12a06e98cb39bb031af13d6b1fc225f9"
    sha256 cellar: :any, arm64_sonoma:  "21ed955b01f0d8bdd8108fe6b5ddffa0c90eb57e747bb0b2dc59c66ddd78f46e"
    sha256 cellar: :any, sonoma:        "fda6da5a238721629336dc6136b3dd332a3ba9a1573ec3277709a03099b4a61e"
    sha256               arm64_linux:   "b29e9a86607c16f976f10ed9c6674875e9c0261d465a4920191b68df1fb88da1"
    sha256               x86_64_linux:  "555db96f572fb18e781cb8875bb73f3c595f2a36159dfd19350822d82e4a718a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  uses_from_macos "libxml2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "https://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    CPP
    command = "#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml++-5.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
