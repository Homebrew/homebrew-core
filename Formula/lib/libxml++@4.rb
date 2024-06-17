class LibxmlxxAT4 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://download.gnome.org/sources/libxml++/4.0/libxml++-4.0.3.tar.xz"
  sha256 "a29c980339af67a4ad51af0c76d459e26c2ff97d2ab838ec8bc4aaac777d1a1b"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(4\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "910221bf89290de87c2aef652df706e1e30e31bfc9d44c9f0a4b5ff3edbb777b"
    sha256 cellar: :any, arm64_ventura:  "c5bd0dd135e7f4d4d9ac6327b06300876eb0d1d29ababa5ef2d4b424e1eb7d40"
    sha256 cellar: :any, arm64_monterey: "e22b5ecadff523e4c4a2a2957d4d2819d05a85785c9e734f1e723f05b2bff1cd"
    sha256 cellar: :any, sonoma:         "70c07bdaf2ff55083ad9308a244b7b96ab010339cb397e624fe55c1f04adffa2"
    sha256 cellar: :any, ventura:        "08a4a583c0e8e65d65e92bd4764b5d7576292275cdcd8fb96665facf6f12b109"
    sha256 cellar: :any, monterey:       "39128c65dbd4d4afe593e11f5d07635657d8ca406bee5e72d94bd15cc70802e2"
    sha256               x86_64_linux:   "1d7e028d6d08082a42531cbd2615b2d7dc9c24be4fe12b6cf07198dfdcca299d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glibmm"

  uses_from_macos "libxml2"

  fails_with gcc: "5"

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
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-4.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
