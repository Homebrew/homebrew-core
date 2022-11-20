class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v2.0.1/geeqie-2.0.1.tar.xz"
  sha256 "89c1a7574cfe3888972d10723f4cf3a277249bea494fd9c630aa8d0df944555d"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "e0f4adc0b1ba1bc1069c04613e133c1b1ea3754d318bb5a83ed8a91f47f63622"
    sha256 cellar: :any, arm64_monterey: "9aea268f6843bd97784c8819b1b7864f95b6a9c0baba6bf4e60fe213190accfb"
    sha256 cellar: :any, arm64_big_sur:  "94b5ef7be0839c42d359a3768d545a99b25bf093533b331a20e4b929a4848e0a"
    sha256 cellar: :any, ventura:        "6501282671b37e9560f0d252cf27c926e919358cd4459dab8ce90ed388d06bba"
    sha256 cellar: :any, monterey:       "1104afb3786b064ea3072c85f30fc8270e8e92907d30003558f9f32946668c14"
    sha256 cellar: :any, big_sur:        "1a3f664e7889bf97ed3865872a46d5039ed45615e00102a1cb093dd94d5fa55b"
    sha256 cellar: :any, catalina:       "e2dec2996f949bf09f887c4bf1c6374efa563c31c41bae8ae121f253f5be53de"
    sha256               x86_64_linux:   "c6b662b72f13d521576f5de5e1614be0057041f768836d33c0053d4345fbb980"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
  depends_on "cairo"
  depends_on "exiv2"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "jpeg-turbo"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "little-cms2"
  depends_on "pango"

  uses_from_macos "vim" => :build # for xxd

  # Fix detection of strverscmp. Remove in the next release
  patch do
    url "https://github.com/BestImageViewer/geeqie/commit/87042fa51da7c14a7600bbf8420105dd91675757.patch?full_index=1"
    sha256 "c80bd1606fae1c772e7890a3f87725b424c4063a9e0b87bcc17fb9b19c0ee80d"
  end

  def install
    system "meson", *std_meson_args, "build"
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Disable test on Linux because geeqie cannot run without a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"geeqie", "--version"
  end
end
