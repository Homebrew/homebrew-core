class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.shaduri.dev/"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/2.0.0/gsmartcontrol-2.0.0.tar.gz"
  sha256 "64817d65e26186fa0434cc133ac8ac40c30f21e30dc261dd43d5390d7801d455"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 arm64_sequoia: "128ae76819a04a4d9cfa711eecebf55b07f59d5a007ed1b9a368167270553855"
    sha256 arm64_sonoma:  "84ce60f8652673c4531db55997f41779405c31ee1d165fea3eed7f266b89eb93"
    sha256 arm64_ventura: "86eb87b6c6d007eab3b58a323f80ca4a207b486826605c0c694b0a251565a584"
    sha256 sonoma:        "16cffebe358aef3cdab67147e5ea7717f13294cd219eb0ec6951667394a6933c"
    sha256 ventura:       "f4a8c65bd56cb36ba342a07fd1c01a946f8601f1b29866e07b8684863caebefe"
    sha256 x86_64_linux:  "a8cee1aa197c314049e6e888dfbf8f9e23945b0d8cb79b4aa2f976c3616be6eb"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "atkmm@2.28"
  depends_on "cairo"
  depends_on "cairomm@1.14"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gtk+3"
  depends_on "gtkmm3"
  depends_on "libsigc++@2"
  depends_on "pangomm@2.46"
  depends_on "pcre2"
  depends_on "smartmontools"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500

    depends_on "at-spi2-core"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "gcc"
    depends_on "pango"
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
