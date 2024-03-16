class Pangomm < Formula
  desc "C++ interface to Pango"
  homepage "https://www.pango.org/"
  url "https://download.gnome.org/sources/pangomm/2.52/pangomm-2.52.0.tar.xz"
  sha256 "34a134126a6484ff12f774358c36ecc44d0e9df094e1b83796d9774bb7d24947"
  license "LGPL-2.1-only"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "cd18207ae92eed87665870c2b76f55568cf0db36d84c6445dd38bd569e630cfc"
    sha256 cellar: :any, arm64_ventura:  "42eaf0a985fcd55ed115820e76520f36396c82c25666615fe7156f780c48c222"
    sha256 cellar: :any, arm64_monterey: "e6ec07f8b8b7f7e206a42470806987191e0dc6b58a402ff48ac04255976002b8"
    sha256 cellar: :any, sonoma:         "1e948092768b2e09d151308e09db507778124211f65ad7c218e1b910eb56052b"
    sha256 cellar: :any, ventura:        "1b58e4b83132b0543bef43664d755c6c88cbcdfc7a90789b667cc7f6e06e818d"
    sha256 cellar: :any, monterey:       "1ba7a9e966980b3a2327879dda6e81894f6e831434071564b1f38fdf782fa38f"
    sha256               x86_64_linux:   "61806e666453338ae13a98aa4ec83337cf14fdca8efcd672201d9a3f3670e838"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "cairomm"
  depends_on "glibmm"
  depends_on "pango"

  fails_with gcc: "5"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pangomm.h>
      int main(int argc, char *argv[])
      {
        Pango::FontDescription fd;
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs pangomm-2.48").chomp.split
    system ENV.cxx, "-std=c++17", "test.cpp", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
