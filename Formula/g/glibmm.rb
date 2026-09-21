class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://gtkmm.gnome.org/"
  url "https://download.gnome.org/sources/glibmm/2.90/glibmm-2.90.0.tar.xz"
  sha256 "e2efa45643f16b9fea2d6299f2f403d672eaeacddf0ff7f8094e1af9b0f5980b"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  # This regex is intended to avoid the `Gnome` strategy's version filtering
  # logic while maintaining the "even-numbered minor is stable" behavior, as
  # minor versions >= 90 are still stable in this case.
  livecheck do
    url :stable
    regex(/glibmm[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7ba4aedc30afd3dfd37ac7d3955e2c9ef8eacf4f006806349c309e604a2f15a0"
    sha256 cellar: :any, arm64_tahoe:       "51649501dc86d69f57c88a5fceb479d0f007dd2e17d740cc714a82f111903ae2"
    sha256 cellar: :any, arm64_sequoia:     "ed5d4e505aa436dde063d19fa2950fd7b796312472f94b4a70e70ae8e701cb15"
    sha256 cellar: :any, arm64_linux:       "b8920ae679ca4d8650770ed434ad78cb7f0125f501f97eb07dc49e98d650d7a6"
    sha256 cellar: :any, x86_64_linux:      "071c26d691365ae87ed42f7a151742a8dac576e798927ba8a8659ea1060c2a5c"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++"

  def install
    system "meson", "setup", "build", "-Dbuild-examples=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    CPP
    flags = shell_output("pkgconf --cflags --libs glibmm-2.68").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
