class Libxmlxx < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.net/"
  url "https://github.com/libxmlplusplus/libxmlplusplus/releases/download/2.42.4/libxml++-2.42.4.tar.xz"
  sha256 "82c7bb4f20a227bba174158be475c1017f650b276f9268923c6601b5a545838f"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "84df77dcb56ba181caaacea0abd5cae1983552c6bb08b09c1b86e3a43640b599"
    sha256 cellar: :any, arm64_sequoia: "8f48f02c9808543f31b804aa23ecfa39a6759cc05c8a9b10527970d262f512f3"
    sha256 cellar: :any, arm64_sonoma:  "9679e1333a8ef9adf286b475282b4b8273d029e498e5cc1e8c675567fc105565"
    sha256 cellar: :any, sonoma:        "54a43a8ddd7948a463e77ac3b63eff573c5b5de92e197167b84a2173807d68d4"
    sha256               arm64_linux:   "f39affc3423afe10d53232fe0a56a32b2dd4651f12126119a98c9fd62bc1c1bb"
    sha256               x86_64_linux:  "d665befce402fa055d6240c7aeb7ebed4f0e1ba8ef8a991e71da041e86ec5473"
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

    flags = shell_output("pkgconf --cflags --libs libxml++-2.6").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
