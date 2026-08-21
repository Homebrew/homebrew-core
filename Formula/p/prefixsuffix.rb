class Prefixsuffix < Formula
  desc "GUI batch renaming utility"
  homepage "https://github.com/murraycu/prefixsuffix"
  url "https://download.gnome.org/sources/prefixsuffix/0.6/prefixsuffix-0.6.9.tar.xz"
  sha256 "fc3202bddf2ebbb93ffd31fc2a079cfc05957e4bf219535f26e6d8784d859e9b"
  license "GPL-2.0-or-later"
  revision 10

  bottle do
    rebuild 1
    sha256               arm64_tahoe:   "67f1d60548d347f793c3416522ea4f6b5ea884f58cdfe6d7ef4f468345818fb3"
    sha256               arm64_sequoia: "ea1addddc2ca75fe7a5af2115e1aac889b31427ec090b2bcfda18424762a0db2"
    sha256               arm64_sonoma:  "5f40e86d1a0aed0f708e54ba07d2b7eb7b51a7b0f08c6d25930d1e5e3b7966f0"
    sha256               sonoma:        "65103955a0c43a6d89ff7cb87d923040d488b64076ffc174cc8a54de2dd15d88"
    sha256               arm64_linux:   "cce97dd8441e779ba1c5795bdb542328504993d5c9d2f9672508d89f2d458d1d"
    sha256 cellar: :any, x86_64_linux:  "ad9e1a4dc06e55b7a45c586eae321c5862fc520d978a283b4f4715af1ac804ac"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "atkmm@2.28"
  depends_on "cairomm@1.14"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "gtk+3"
  depends_on "gtkmm3"
  depends_on "libsigc++@2"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
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

  post_install_steps do
    compile_gsettings_schemas
  end

  test do
    # Disable this part of the test on Linux because display is not available.
    system bin/"prefixsuffix", "--version" if OS.mac?
  end
end
