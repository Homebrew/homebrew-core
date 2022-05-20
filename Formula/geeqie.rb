class Geeqie < Formula
  desc "Lightweight Gtk+ based image viewer"
  homepage "https://www.geeqie.org/"
  url "https://github.com/BestImageViewer/geeqie/releases/download/v1.7.3/geeqie-1.7.3.tar.xz"
  sha256 "25b1f71cf91bd9a96f399d2a9e70507e54bb377a56e64d89521c0f7a9ce5dd38"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "60cfcddc21cb1b57a573f7833485c87d9650bd5f820bce0a7b61aaa577e68300"
    sha256 cellar: :any,                 arm64_big_sur:  "8f25f4a5efcdd565d2e50cf5eb5719c35659f41f46ca3eac8bda1f483cc40955"
    sha256 cellar: :any,                 monterey:       "c09db7a534786d7c1af6b45fa1ba98ac116421ee89910796f7ba9469611c38bc"
    sha256 cellar: :any,                 big_sur:        "fcf8116b7271002a44ce9ee5c5f6084ecf45d98593f4d6b11bc31dd13fd66976"
    sha256 cellar: :any,                 catalina:       "63b48ec4c18d21a0b0298a6dffdd9bd7821b2708efc33d2ce2b39c60285b9f44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "415a5be1b418bcc0e8ad1789b47fc671e5588dda79a0ebd31fc1ba16670dc0fe"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "intltool" => :build
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
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "little-cms2"
  depends_on "pango"

  uses_from_macos "perl" => :build

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    ENV["NOCONFIGURE"] = "yes"
    system "./autogen.sh" # Seems to struggle to find GTK headers without this
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-glibtest",
                          "--disable-gtktest",
                          "--enable-gtk3"
    system "make", "install"
  end

  test do
    # Disable test on Linux because geeqie cannot run without a display.
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/geeqie", "--version"
  end
end
