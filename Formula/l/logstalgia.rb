class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "https://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.4/logstalgia-1.1.4.tar.gz"
  sha256 "c049eff405e924035222edb26bcc6c7b5f00a08926abdb7b467e2449242790a9"
  license "GPL-3.0-or-later"
  revision 7

  bottle do
    sha256 arm64_sequoia: "768960af5482c74e6126145fa692ff49292fb22d0648a9851dbb5100d23a3147"
    sha256 arm64_sonoma:  "0c14a3f043b5c93602f4c95fcd20db618161a14f6f8ccb2c2cef7be97e54295f"
    sha256 arm64_ventura: "22e4603221b1a7a1a33fe226239c57bca7250112faad244223a2c7c60db7339e"
    sha256 sonoma:        "5090c058761cccc7936e6f9c311fd132e03929be2d4b999fda72cc2e70a49935"
    sha256 ventura:       "fd28fb16ed3c1b59c82b70241ae6672cb92eb8a84e7700ba5021d815b0e05bad"
    sha256 arm64_linux:   "8bff97fc0e0999bb92e37a2dbb672dbfb18c1f540f299c797fa0ecbed101e8c2"
    sha256 x86_64_linux:  "336dd49091c4ce92ee67c14b1c793c9caba7417537c5bc98c0e89f97fdae3c8e"
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkgconf" => :build

  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    ENV.cxx11 # to build with boost>=1.85

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--without-x",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
