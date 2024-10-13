class LibxmlxxAT3 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://download.gnome.org/sources/libxml++/3.2/libxml++-3.2.5.tar.xz"
  sha256 "0c9b381b5a83d6b3ab4b0b865d7256dab27d575981b63be2f859edcb94da59c7"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(3\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "7ce50fce8fe1b14be32287b69d5216ad21c121f07cf4fe654520906f023ba329"
    sha256 cellar: :any, arm64_sonoma:   "24048f05e398ac690679138eea7b2ae75ad039aa0dc7616ab51c314a82cfb7a8"
    sha256 cellar: :any, arm64_ventura:  "b01bd711325b71e9252edd6c8f82b5469bfeb5a397543d8a4fd3c59899ed5147"
    sha256 cellar: :any, arm64_monterey: "7804cbaa7dbf277c45f5b9809c7d5297a4e9837fee3cb543b3ceba8fbef04740"
    sha256 cellar: :any, sonoma:         "050e445cd107995689ad66b20ca04f3ba3aae67f6c86b7c9183579a8700b31e4"
    sha256 cellar: :any, ventura:        "7b542bcf4c2050560374ad3c63c20f991e02b9e509b66bf1b61422af8b93d499"
    sha256 cellar: :any, monterey:       "d290a2d84feaca38d27ab3216b5ec7eaaef2871a489cfcc55bfe174167fda470"
    sha256               x86_64_linux:   "5d1a2e15002dccef5913a648e092cd78d94f987afe7abf14ff30bcbec3b52bb4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glibmm@2.66"

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
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-3.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
