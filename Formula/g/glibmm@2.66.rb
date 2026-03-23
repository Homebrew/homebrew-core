class GlibmmAT266 < Formula
  desc "C++ interface to glib"
  homepage "https://gtkmm.gnome.org/"
  url "https://download.gnome.org/sources/glibmm/2.66/glibmm-2.66.8.tar.xz"
  sha256 "64f11d3b95a24e2a8d4166ecff518730f79ecc27222ef41faf7c7e0340fc9329"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.gnome.org/sources/glibmm/2.66/"
    regex(/href=.*?glibmm[._-]v?(2\.66(?:\.\d+)+)\.t/i)
    strategy :page_match
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0c1ef812fc07213aeda2ad8824cc2626a903114d01b327e2d420c97d1226fc94"
    sha256 cellar: :any, arm64_sequoia: "23856032138e148a0d7103a50a4f52a3401dc95ce471db2e345500078af5af18"
    sha256 cellar: :any, arm64_sonoma:  "e504bb467b2d501f1a51c18833d3230997065b3b7e709d26cd12edd0699bc9c6"
    sha256 cellar: :any, arm64_ventura: "df3a2168179942bd0e30135c2d38acd4819bc7f60c88afe31095c130e1be62fc"
    sha256 cellar: :any, sonoma:        "1c4613edf05f61e532e5841f44041293eef53189381b758b4cc60726246b4537"
    sha256 cellar: :any, ventura:       "04edc9e5e563d89579423112db929789dff6e422835cbb8d7ce24871f9c24c69"
    sha256               arm64_linux:   "c0c03f9078ccc7189c9945b060bd044830a446d8c6259bc9501e5a8970fe388a"
    sha256               x86_64_linux:  "721d4fc5d0339dcc7b41a0429df354191030f838232c62066139b79ef149f643"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "libsigc++@2"

  def install
    system "meson", "setup", "build", *std_meson_args
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

    flags = shell_output("pkgconf --cflags --libs glibmm-2.4").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
