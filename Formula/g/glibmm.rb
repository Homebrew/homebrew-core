class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://gtkmm.gnome.org/"
  url "https://download.gnome.org/sources/glibmm/2.88/glibmm-2.88.0.tar.xz"
  sha256 "a6549da3a6c43de83b8717dae5413c57a60d92f6ecc624615c612d0bb0ad0fe2"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "004d7f1ab6701eb47259e35466edede4a59c1a9f224018000e71ee0d82bbd411"
    sha256 cellar: :any, arm64_sequoia: "b9a29a482b2dcf1fe705476bcdcbc363c48fa2cbaa05b5132b4d4509d6ce0310"
    sha256 cellar: :any, arm64_sonoma:  "466bf9f96c97bac7dad5747b089aa5a527357434651c59ee3a4574c6862ae75a"
    sha256 cellar: :any, sonoma:        "c074041d507860b7da2e5c39321d5112ebd9065b3a6260c812d9c4ea2513a5ee"
    sha256               arm64_linux:   "18b0c3b26d6d8f266fd4466f8577fe90ce40c1197d28f87e9dee421f0b4de70d"
    sha256               x86_64_linux:  "1e806c45a2aaa2c21a79dc61369ff79f4b2ff72fdcdb6f610f1e6d3b294ac0ff"
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
