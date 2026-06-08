class LibxmlxxAT3 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://github.com/libxmlplusplus/libxmlplusplus/releases/download/3.2.6/libxml++-3.2.6.tar.xz"
  sha256 "376608a97e80e2b0ec171c2445f979d7d45c14036a74878adea98554928d4f79"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c0e534a9ad3503e450e9b181d082348cc4302cc5a197d16b49cc9840241216be"
    sha256 cellar: :any, arm64_sequoia: "0e7b5d18b0c3aed586b4db1de668457b3f29b248b712ee800d9c38e09db0e8a4"
    sha256 cellar: :any, arm64_sonoma:  "e6238e8c4625b9669b5c99f519850e22316871e57acc853f08f09bbdc096d6ae"
    sha256 cellar: :any, sonoma:        "71a3cdcf9eeb59436cadef520056386d1baf4dcb31135319f9cceaaf327ff543"
    sha256               arm64_linux:   "cef54a566a50d67deea2fbe51eba5a4ba24db2b8ccf073752f12e1bbbbe09cd1"
    sha256               x86_64_linux:  "f1d3efefe7035eae3c17c7d080629b6a4a5ac77e2f4c81ea8a096221a3f21bc2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glibmm@2.66"

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
    command = "#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs libxml++-3.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
