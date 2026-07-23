class AtkmmAT228 < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.28/atkmm-2.28.5.tar.xz"
  sha256 "ae449192a582a2582a95e0602b15d792bbd639e836339b81ef916aa87540ac5c"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/atkmm-(2\.28(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "705de48adab70c424550dc780e5605f793cdded64693e31ac89dfc89b6cc78b8"
    sha256 cellar: :any, arm64_sequoia: "33cf53b6543685306f355219df4868756989754d68241ed2261f60166a1e9d84"
    sha256 cellar: :any, arm64_sonoma:  "d529dc45c703e2701ea071875a552df76a88dbad5952e25bc1508a68a07177c6"
    sha256 cellar: :any, sonoma:        "8d00c4665d3776f37519d276675fe3f678a6d763a23103f3f33d10168be23655"
    sha256               arm64_linux:   "8eaf1ae166256b15fd53483a1eb2bb799e813e9f0af7c86b983a754d9a8d6a12"
    sha256               x86_64_linux:  "66fe6c72737ac6e46980d801c614b3960e2d4f3883f884ba28820c87e9a339bc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "at-spi2-core"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "libsigc++@2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <atkmm/init.h>

      int main(int argc, char *argv[])
      {
         Atk::init();
         return 0;
      }
    CPP

    flags = shell_output("pkg-config --cflags --libs atkmm-1.6").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
