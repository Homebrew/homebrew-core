class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.shaduri.dev/"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/2.0.1/v2.0.1%20source%20code.tar.gz"
  sha256 "9a7e4fefc34aef7358a5196633e89924ff1e94e721b53609a51af68b1902a947"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 arm64_sequoia: "e875029759200a2c4bd7f8b7e175674a480c82f2fc41fe59b5e56275f6140061"
    sha256 arm64_sonoma:  "c2d68195ae4cc20596e46ea5bae1c2130c77bc45750e902b22956c4acc8d5dc4"
    sha256 arm64_ventura: "10607b6d069fdf1dda25c09523269ed3bb22d4a13698ded27faaa67dd40e489e"
    sha256 sonoma:        "f5dc8c9ca3d57f2b5f6ed089dc4307551a5f8c2af87c75a46d80c72338fdb7c1"
    sha256 ventura:       "43f9947df585e4a457e3a127dcb66da734955658e148845fa2b432e14f382edc"
    sha256 x86_64_linux:  "e23627ffc2e440c984c9927a797936442244af1e6f68765d70614ce173a7bba8"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "at-spi2-core"
  depends_on "atkmm@2.28"
  depends_on "cairo"
  depends_on "cairomm@1.14"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gtk+3"
  depends_on "gtkmm3"
  depends_on "harfbuzz"
  depends_on "libsigc++@2"
  depends_on "pango"
  depends_on "pangomm@2.46"
  depends_on "pcre2"
  depends_on "smartmontools"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500

    depends_on "gettext"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "11"
    cause "Requires C++20"
  end

  def install
    ENV.llvm_clang if OS.mac? && DevelopmentTools.clang_build_version <= 1500

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system sbin/"gsmartcontrol", "--version"
  end
end
