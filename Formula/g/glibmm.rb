class Glibmm < Formula
  desc "C++ interface to glib"
  homepage "https://gtkmm.gnome.org/"
  url "https://download.gnome.org/sources/glibmm/2.84/glibmm-2.84.0.tar.xz"
  sha256 "56ee5f51c8acfc0afdf46959316e4c8554cb50ed2b6bc5ce389d979cbb642509"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "edf8bcf72de18d7fe8211708c8af4332014a134e287b9c24744ec254f69e0492"
    sha256 cellar: :any, arm64_sonoma:  "0e10948c6053182c212b515fd97a02d553c66ee95da948d326d7aa1343bf7d51"
    sha256 cellar: :any, arm64_ventura: "26030e6c8cd469219d07ee2f19bf5274e9d316bcda74c6d67855d4fdd1ed0be8"
    sha256 cellar: :any, sonoma:        "fa675395706ee513072096bea13f53bc5d709a2040795d02557d0e8c7c2097c2"
    sha256 cellar: :any, ventura:       "0ec2eaaa0e492ac7bad58a8933ddf4e7a45d0cf8f390e11857bf13c5c5428db8"
    sha256               arm64_linux:   "f8fa77e5cb936ef421893f3b85d516ac448bc7d50e7ef8a9b98e087fb9bf79b1"
    sha256               x86_64_linux:  "202ff3d3acdad3252ea3ce5f8b078a7494c91bce22e1d980fd518fc9a521c6bf"
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
