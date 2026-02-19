class LibxmlxxAT4 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://github.com/libxmlplusplus/libxmlplusplus/releases/download/4.4.0/libxml++-4.4.0.tar.xz"
  sha256 "02365465f62c7c8fe38618da8805fd8d8fd18544cd88b18c39098995513787bb"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1e04e6bfb0b3cc19ff05dcd146ea78d30f9a55e7376e4ba95d93cf1f9c2224f5"
    sha256 cellar: :any, arm64_sequoia: "4719a9f8b113d505e90963437ae9f5cac16b486f1d446f416946800e251160cd"
    sha256 cellar: :any, arm64_sonoma:  "ed5ac747da5419755ff6ff6b647f60028b7e03483dcfee50c0634600fb0f54c7"
    sha256 cellar: :any, sonoma:        "d8e7a9c15686a095e503026b73c80cb4b2f74aa3212d894912d123ecc7298ca4"
    sha256               arm64_linux:   "6369f95363a411ac8b1de7a3d51b9b437bfea9432f89443500ea073fdecab1e9"
    sha256               x86_64_linux:  "046a2ee75cafd9694e66eee8caf210a18a327aa78e792c27554acaa352f04685"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glibmm"

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
    command = "#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml++-4.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
