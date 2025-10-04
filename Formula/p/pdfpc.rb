class Pdfpc < Formula
  desc "Presenter console with multi-monitor support for PDF files"
  homepage "https://pdfpc.github.io/"
  url "https://github.com/pdfpc/pdfpc/archive/refs/tags/v4.7.0.tar.gz"
  sha256 "0083a958a2e9288a15c31aabb76b3eadf104672b4e815017f31ffa0d87db02ec"
  license "GPL-3.0-or-later"
  head "https://github.com/pdfpc/pdfpc.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "b76907d094e032d1c6d6f67be0b1774b0ceaaad44ec21102fcb82084ae8c94c2"
    sha256 arm64_sequoia: "76900b6a726ed5f8c747a89957da0b81dd8b18c8b5bda6765f7b1ac4de0c26de"
    sha256 arm64_sonoma:  "bfbfbdcfb242b5ca2c26764e5175596609bed8b681692a07cc3cf80e1a351de9"
    sha256 arm64_ventura: "102466bc213e5b6a13b8285441a3c3a22b80f73f47f197481cf20ea4331b6e71"
    sha256 sonoma:        "c4b524c67133b5517f563706ba4ef91438ec35d0248ff362ef83147a612c9ae1"
    sha256 ventura:       "b3074deef95572bbd9128bc964db5f8099b627a93a5d1c63b1f10db35c9f1939"
    sha256 arm64_linux:   "b1d11c2674eedab4f24630c2f9dc2888815feaa14a321d29e237045890e2b01d"
    sha256 x86_64_linux:  "243cdb84ac1abdc284cc3ff854d68344f549cc4cb94755eccd7b5c20e1c892b7"
  end

  depends_on "cmake" => :build
  depends_on "vala" => :build

  depends_on "cairo"
  depends_on "discount"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gstreamer"
  depends_on "gtk+3"
  depends_on "json-glib"
  depends_on "libgee"
  depends_on "librsvg"
  depends_on "libx11"
  depends_on "pango"
  depends_on "poppler"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "webkitgtk"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DMDVIEW=#{OS.linux?}", # Needs webkitgtk
                    "-DMOVIES=ON",
                    "-DREST=OFF",
                     *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Gtk-WARNING **: 00:25:01.545: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system bin/"pdfpc", "--version"
  end
end
