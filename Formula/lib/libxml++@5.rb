class LibxmlxxAT5 < Formula
  desc "C++ wrapper for libxml"
  homepage "https://libxmlplusplus.sourceforge.net/"
  url "https://download.gnome.org/sources/libxml++/5.0/libxml++-5.0.3.tar.xz"
  sha256 "13074f59e3288a378cafe9e6847df17f764c23fa29bc94f3305b8bf81efb2cf7"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libxml\+\+[._-]v?(5\.([0-8]\d*?)?[02468](?:\.\d+)*?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "44b7d0a7b1df798e24fe089f756d7cb753f61a255032656b98bbd9eaa875d687"
    sha256 cellar: :any,                 arm64_monterey: "402886e8723705afd171a13979fd1747248dbd84921ddd4bf24b858a7480c016"
    sha256 cellar: :any,                 arm64_big_sur:  "e65f8bd5d6cb617dc604bf1314e16f63d517bf7093946300009666adc6588c7d"
    sha256 cellar: :any,                 ventura:        "1d885ff317148d2287d6d412588610820ca1d5fe319ef701a3d437d618fc13fc"
    sha256 cellar: :any,                 monterey:       "628476efe87ca3733d28ba8e2475fd970c06b82329c8abdbd1410d21714de7af"
    sha256 cellar: :any,                 big_sur:        "3865e4b03542d13e2b08da4cd6e03c6997ea2b60fb67b1b270dadf5247afc701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc9d878e7bf2c2d942eb652457f1b4e6ddee47c98c9e931e235a6490ded7e828"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.11" => :build

  uses_from_macos "libxml2"

  def install
    ENV.cxx11
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
    command = "#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libxml++-5.0"
    flags = shell_output(command).strip.split
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
