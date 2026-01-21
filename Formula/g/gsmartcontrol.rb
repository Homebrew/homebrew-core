class Gsmartcontrol < Formula
  desc "Graphical user interface for smartctl"
  homepage "https://gsmartcontrol.shaduri.dev/"
  url "https://downloads.sourceforge.net/project/gsmartcontrol/2.0.2/gsmartcontrol-2.0.2.tar.gz"
  sha256 "7cebd83fd34883d51e143389aa88f8173ea7b67c760b12b7de847f3c3c8cee34"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    sha256 arm64_tahoe:   "cfaf1237a9a274431f67a88627cb0a794662c85d083d2e7dd46083422ca821c4"
    sha256 arm64_sequoia: "fec689ece510c21ae0589fce4d135a403f7b59904e2fd565d00079a21d3cf2e2"
    sha256 arm64_sonoma:  "dfb1e49374740cbeb2392d5b645e12df3669389f45e575eae5114cf2bbd89f4b"
    sha256 arm64_ventura: "06c41cd9e482c9477e5e06131536cd9b678d52bf4e547cfc48414eb645ec4fd0"
    sha256 sonoma:        "3c772fa791354268934693ea60962ffbe839ca07219b9a69925e7bd862d0ff61"
    sha256 ventura:       "244de0b2b1617a8a7f71210230f94fd32d3f77a87745a4e3a893e6621e1da4f2"
    sha256 arm64_linux:   "5213f0cf402797e0e3d08a4ed283272fa701bf0ff1a876b468eedf4489464086"
    sha256 x86_64_linux:  "6cd4fa97e19fee44f12fe02e4d7edf882c098c80d83472d036d61f8e730c7b81"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "atkmm@2.28"
  depends_on "cairo"
  depends_on "cairomm@1.14"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gtk+3"
  depends_on "gtkmm3"
  depends_on "libsigc++@2"
  depends_on "pangomm@2.46"
  depends_on "smartmontools"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1500

    depends_on "at-spi2-core"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
    depends_on "pcre2"
  end

  fails_with :clang do
    build 1500
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "10"
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
