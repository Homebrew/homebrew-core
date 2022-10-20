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
    sha256 cellar: :any, arm64_monterey: "860a3949cceee885007e27034a9db220398ff40df5a2a58cb919afe2895acf96"
    sha256 cellar: :any, arm64_big_sur:  "a5b2b2ef0fb4106053a0e100cbc361a9bc0f0d91c34808470578d9bd788ed28c"
    sha256 cellar: :any, monterey:       "4bc31f8c599e8f752735e25b1dfea85516e2f2a41754ec9ecaf64c36ea5ebef1"
    sha256 cellar: :any, big_sur:        "93a8152b63a8564567b6cdfc75ae1a349d2a991892d49e9e6947d0c2c66b8b98"
    sha256 cellar: :any, catalina:       "8890f0e5db193335b99d902825d165146afa76b886815662efffa5f8a6f5d6e4"
    sha256               x86_64_linux:   "4d173d0da7108b608ba24ccef48b0d5b212f7cda6f6b95e06765136606b02450"
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
