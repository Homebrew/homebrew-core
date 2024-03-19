class GlibmmAT266 < Formula
  desc "C++ interface to glib"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.6.tar.xz"
  sha256 "5358742598181e5351d7bf8da072bf93e6dd5f178d27640d4e462bc8f14e152f"
  license "LGPL-2.1-or-later"
  revision 1

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.66/"
    regex(/href=.*?glibmm[._-]v?(2\.66(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1848c1f041ad22a6c899a0c7ee8ccc3b6dea1781b9bf4d9564d7851d78607705"
    sha256 cellar: :any, arm64_ventura:  "23e6fa6e6598d42905277b74b509a051df603a79991127f17f3ccb8d5eba9fa1"
    sha256 cellar: :any, arm64_monterey: "929130f8833b167c524041f3f1eb7fddd64fa666135457d7bfdf76322d5edbe4"
    sha256 cellar: :any, arm64_big_sur:  "dd3a1e08b76e300719a09e121993390e6cfa396a2c58f77a0b124b4440496987"
    sha256 cellar: :any, sonoma:         "38a1437ff54f2d77581e834e57f11fc240d8131b1680e6a2071f2e1e1266d97b"
    sha256 cellar: :any, ventura:        "0e5e18234e4b0b9ae0bbd2d0cf1b3b5aa6dcb464db0df9e91cb4df4a63d51178"
    sha256 cellar: :any, monterey:       "5fb9029181687d058c031402d2adc4ef8cefe6ca373c1a99ceb5bfbc261c9527"
    sha256 cellar: :any, big_sur:        "4ecf012c25966ef6d88647ac5c596fe50d43fd6bff2e724e8a6ed4a3f5992838"
    sha256               x86_64_linux:   "d80a0b4f58e55b0af0e3156e822ce3b1ab699ff298328d9eb9df02c00e927fef"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++@2"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glibmm.h>

      int main(int argc, char *argv[])
      {
         Glib::ustring my_string("testing");
         return 0;
      }
    EOS

    flags = shell_output("pkg-config --cflags --libs glibmm-2.4").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
