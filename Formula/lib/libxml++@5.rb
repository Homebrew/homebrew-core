class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://download.gnome.org/sources/libxml++/5.4/libxml++-5.4.0.tar.xz"
  sha256 "e9a23c436686a94698d2138e6bcbaf849121d63bfa0f50dc34fefbfd79566848"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f700d5c85e52fa89adbd2fab8f8b73e071e52ab9aaef45121968209ce90a4f59"
    sha256 cellar: :any, arm64_sequoia: "74ece1a21d1acc4aaf4f9895837de84aaf37855e309877213266aed5bfe7c2bb"
    sha256 cellar: :any, arm64_sonoma:  "394658c92c750312e8f6ecaad34237bf6ab12a3897b810f2ad4e06349fd41f8a"
    sha256 cellar: :any, sonoma:        "c04b51736c024ee77ebfbed0f850f05c9273dcfb9a90a1ae23eb426a00de23de"
    sha256               arm64_linux:   "d300722e3348737fceeec7ffeb0722a1cb598bfe0c3e1f8253935e6509df5722"
    sha256               x86_64_linux:  "70cf96991d0a83886ea06882bce125f42c209d2b932800eb6ac2359f6b92de5c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  uses_from_macos "libxml2"

  # Fix naming clash with libxml macro
  patch do
    url "https://github.com/libxmlplusplus/libxmlplusplus/commit/662ee970644b381720d8750b07844745b78782e2.patch?full_index=1"
    sha256 "459dfc7a45e19d8b2ca49d4a8db982ba46cbad9384a82218f43e61fb1bfc5182"
  end

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
