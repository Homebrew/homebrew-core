class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.9.tar.xz"
  sha256 "fc3202bddf2ebbb93ffd31fc2a079cfc05957e4bf219535f26e6d8784d859e9b"
  license "GPL-2.0-or-later"
  revision 10

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_tahoe:    "9685f6462cb7c8c464ba24562d8d79038c4982fa6e173765570d11d7d2fef6bb"
    sha256                               arm64_sequoia:  "30ef0ba35485343f36734f212295160cedd798991dfa2abd35a6b60f7f95405e"
    sha256                               arm64_sonoma:   "6e197205c70b3923ae50f5f33bd203810348f2846a3eabaf86839a978c598426"
    sha256                               arm64_ventura:  "8a718e3a241904ac15db3d608b23d2450743cd649168f623d3033717ef604939"
    sha256                               arm64_monterey: "c61092d6a233b89eba50ad58cd33acdf79110cececfe86b4b9c00c1a8713af58"
    sha256                               sonoma:         "e5750bf2bc2db7e78a87ce10a8e348c15b6cc8f560a1ee4f97dafcd3968a8dc9"
    sha256                               ventura:        "5226011c5383e3328b4872a1e559ce249b5da4f817c7d4bfab2d417ce0fc095f"
    sha256                               monterey:       "4a0a8c588c5d78a1bffbeeeb1f6dc566fb1ff39de91900ce2d089af27e19fd5e"
    sha256                               arm64_linux:    "74bcf8905a1953a54f17b65d4c68b48d0fb78e0d5f3988204e99620aa6b474bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bd8de221d43b7d0d511a7a0cb6ebd3a35f045524a02917cf839eb426ae65d41"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "atkmm@2.28"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gtk+3"
  depends_on "gtkmm3"
  depends_on "libsigc++@2"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "cairomm@1.14"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
    depends_on "pangomm@2.46"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    ENV.cxx11
    system "./configure", "--disable-silent-rules",
                          "--disable-schemas-compile",
                          *std_configure_args
    system "make", "install"
  end

  def post_install
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
  end

  test do
    # Disable this part of the test on Linux because display is not available.
    system bin/"prefixsuffix", "--version" if OS.mac?
  end
end
