class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://github.com/libxmlplusplus/libxmlplusplus/releases/download/5.6.1/libxml++-5.6.1.tar.xz"
  sha256 "4996e8a73995e8a4cd656c8591dce38181146edfc30cb47c97d1db3c56990ad7"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9164e86885c4769a04bf9711aa946ea8cfe328cfecb9cf9e46ed2016eb486631"
    sha256 cellar: :any, arm64_sequoia: "d44a81966c4c22de6570a6c7ad8078974b0ac11fa06fe16259e18f6f789fca86"
    sha256 cellar: :any, arm64_sonoma:  "c53d66642a81bb8c6e18f6f33c7ff6a77e5a9a678d0957a90b6e691ac8b77fb8"
    sha256 cellar: :any, sonoma:        "c1945550caf17babeac73a8c274b8b68f5428ef34408282ba2ad97eeb1b8d657"
    sha256               arm64_linux:   "572191e564ec5e0bb275351f9892b7543030de1afeaa9c7b92ef517e8fb6a08e"
    sha256               x86_64_linux:  "63823e5e5eeedca47bff04ee8602292563a19a3fc8a9bec4c2db1e7c8521ebce"
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
