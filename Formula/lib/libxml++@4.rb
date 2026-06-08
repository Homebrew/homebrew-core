class LibxmlxxAT4 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://github.com/libxmlplusplus/libxmlplusplus/releases/download/4.4.1/libxml++-4.4.1.tar.xz"
  sha256 "110df9efc4cbc6b2e83a25796075ba7ca4934951a29e1c34e1962b2c1b205614"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "74c88e82cc26ff66b8ae3e718b45b190ca61129c2f8956e9955c2599b632262d"
    sha256 cellar: :any, arm64_sequoia: "5dafbc9ef052479db900d124e96eeea36bcafb3c27f3836652bd6cf722b4dc7f"
    sha256 cellar: :any, arm64_sonoma:  "5f42860028fdaa0dc0e9d45c83e17deaa737423facd5c4235a9ae8c534dfb412"
    sha256 cellar: :any, sonoma:        "66451d3c7febd2ef337e6c3503250f1739e9e47354961ab0e726dbcc6ab78b12"
    sha256               arm64_linux:   "0cf103276a9b86fc93d251c27650e0635f7d93d12d7e2e3f37da2f3c51dc0d92"
    sha256               x86_64_linux:  "2d1af6cd7db7d0372663f41253e0d0acac29be01397db7084ae27926d568f977"
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
