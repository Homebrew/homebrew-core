class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v1.7.3/geeqie-1.7.3.tar.xz"
  sha256 "25b1f71cf91bd9a96f399d2a9e70507e54bb377a56e64d89521c0f7a9ce5dd38"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3b3cf00e0d5942d061756b850edc8675a7fcbef19bb44db675deab85f2f89b49"
    sha256 cellar: :any,                 arm64_big_sur:  "a16904a1405682d3f7b2ce364349a13b849d8484bc64d3ed6e50a5b039c0602c"
    sha256 cellar: :any,                 monterey:       "0b11ddf837b2078f6732f993a86fb38bd09b75e1d759e75f4ab6a4a25a261c99"
    sha256 cellar: :any,                 big_sur:        "b0a079d4973057f1d6ff163c9bac4313ca8e1ee458aa31a46e76fa93c001e77f"
    sha256 cellar: :any,                 catalina:       "64b9a1210db86f04315c80a722feef26fd428b19625e9d9c3da71059b1697912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d4a1a0535b8015c07d3a490e454216480af9d68d67e00e16af779d3aeaa9a57"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
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

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh" # Seems to struggle to find GTK headers without this
    system "./configure", *std_configure_args,
                          "--disable-glibtest",
                          "--disable-gtktest",
                          "--enable-gtk3"
    system "make", "install"
  end

  test do
    # Disable test on Linux because geeqie cannot run without a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"geeqie", "--version"
  end
end
