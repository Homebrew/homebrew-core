class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://download.gnome.org/sources/libxml++/5.4/libxml++-5.4.0.tar.xz"
  sha256 "e9a23c436686a94698d2138e6bcbaf849121d63bfa0f50dc34fefbfd79566848"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "8b1741fec20807f621a0565fad5b10fff46bdb5e092f7545ccbe7c776d394b5b"
    sha256 cellar: :any,                 arm64_sonoma:   "5437f74e7361d06081dc6da97cd8f7726a0ae705e8157e1a0fc631214904eb37"
    sha256 cellar: :any,                 arm64_ventura:  "4e43cbec05cadeb4a37ac6c820e23e83ab127c5b06660fb2942c3bb9f1bf2927"
    sha256 cellar: :any,                 arm64_monterey: "ea823fac5dc9c1bb716221a7ebe7567e612ac76bb3b6d2a8c146d69f96b0492e"
    sha256 cellar: :any,                 sonoma:         "d55199dafe752477e6db5375a0635b9ca76ae444288f6ef3d1de9c5ce6e58ddd"
    sha256 cellar: :any,                 ventura:        "fc8d4eb8e4bd8d3eb20b7942557202b9628c5933058bb83c5621f93f4c0b047a"
    sha256 cellar: :any,                 monterey:       "b38022f1cbc5d07e4c5969b98849c218823863f8ec97faf3680cb77545c4c343"
    sha256                               arm64_linux:    "04bd576bd7befe5da3d2cc17ce5ab1f2232356228e033162aff468209222d9ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e0691b094a3ab56f2add27e4cf43a8d7f6d79a13a61d9fe97d243e2956c6fff"
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
