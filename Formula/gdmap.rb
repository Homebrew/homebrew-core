class Gdmap < Formula
  desc "Tool to inspect the used space of folders"
  homepage "https://sourceforge.net/projects/gdmap/"
  url "https://downloads.sourceforge.net/project/gdmap/gdmap/0.8.1/gdmap-0.8.1.tar.gz"
  sha256 "a200c98004b349443f853bf611e49941403fce46f2335850913f85c710a2285b"
  revision 2

  bottle do
    sha256 arm64_monterey: "0434aca36b5815b56ed272593d2c932c9021f98096b69948345326c6d4385711"
    sha256 arm64_big_sur:  "5a8b13614d00034566780fe17bfdffa2e3e9c08a10953de82b7f1e162f6846cb"
    sha256 monterey:       "3800ceb5b5a901034bfb7db80fda28a0015fc7479e899b3013bfc61f0b230629"
    sha256 big_sur:        "a362457b2b3e0cba8a2b88555e794a2cd9a5c0b17591c632f3cc27e3e85777c8"
    sha256 catalina:       "d465a02727acca541229325a9d3ffa79e1ef9693512da5b1d3a3b37437fbe00d"
    sha256 mojave:         "9c178f409b81ce7808efe356bf09d82804265de11d4527dcc1dea20948a76b16"
    sha256 high_sierra:    "1f82d4cf21c4166fd579e132e3ecf7302179cba2d6b19bf33ef18618f5354416"
    sha256 sierra:         "2a5da8dc2b00407271001ef511d61cad03f043cc98b45442ab1aff7d9263ae19"
    sha256 x86_64_linux:   "89e1c3ad339cc74e03548a784171f218f5d8f7216749ee9c0a8bed3086c5aae1"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+"

  uses_from_macos "perl" => :build

  # The code depends on some GTK macros that are flagged as deprecated in the brew version of GTK.
  # I assume they're not deprecated in normal GTK, because the config file disables deprecated GDK calls.
  # The first patch turns off this disablement, making the code work fine as intended
  # The second patch is to remove an unused system header import on one of the files.
  # This header file doesn't exist in OSX and the program compiles and runs fine without it.
  # Filed bug upstream as https://sourceforge.net/p/gdmap/bugs/19/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/gdmap/0.8.1.patch"
    sha256 "292cc974405f0a8c7f6dc32770f81057e67eac6e4fcb1fc575e1f02e044cf9c3"
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", *std_configure_args, "LIBS=-lm"

    system "make", "install"
  end

  test do
    system "#{bin}/gdmap", "--help"
  end
end
