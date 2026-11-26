class LibxmlxxAT2 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.github.io/libxmlplusplus/"
  url "https://github.com/libxmlplusplus/libxmlplusplus/releases/download/2.42.4/libxml++-2.42.4.tar.xz"
  sha256 "82c7bb4f20a227bba174158be475c1017f650b276f9268923c6601b5a545838f"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(2\.([0-8]\d*?)?[02468](?:\.\d+)*?)$/i)
  end

  bottle do
    manifest_sha256 "047a7752e06b0e72671179cc3db6897116ef8d75528e8c353f436de67d83d758"
    sha256 cellar: :any, arm64_golden_gate: "b1950a7f86abb8d95b1b3fe8e20d44847a30b8d0bf0b30f6eaf86b4fc1bcda2d"
    sha256 cellar: :any, arm64_tahoe:       "8ac8b0ebf67cbcbba33edfda3e2318ea3743730754f43b520ee9ff11af690e0f"
    sha256 cellar: :any, arm64_sequoia:     "206c7c4c2cabef67fd3acf77297f40f3580aaee97aca7458562579ce21b2a7df"
    sha256 cellar: :any, arm64_linux:       "ca28dd2ef9da740aa00f85772912935e2ca4807eacf9e7e5438b1d6b34d09991"
    sha256 cellar: :any, x86_64_linux:      "4068a0a15c039c3d45bf64490fde3fc24872bc1cd767dd178a7a926e0de240b5"
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
