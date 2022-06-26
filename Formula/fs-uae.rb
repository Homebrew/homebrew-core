class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/files/FS-UAE/Stable/3.1.66/fs-uae-3.1.66.tar.xz"
  sha256 "606e1868b500413d69bd33bb469f8fd08d6c08988801f17b7dd022f3fbe23832"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://fs-uae.net/download"
    regex(/href=.*?fs-uae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b9f361e0cc2b048aedb761409cd9a79c34c98ebaa22a35c426b4a42e93884933"
    sha256 cellar: :any,                 arm64_big_sur:  "0caec2b541d80f8645decd87cabdb34e327844afaf5c06b526572eb52d3526ec"
    sha256 cellar: :any,                 monterey:       "e73f955c331c42ddcbada8c15dcaaba7aa3c4c1f2471b6303ca920d90977b6c8"
    sha256 cellar: :any,                 big_sur:        "7d0fa0057f0d4e76d802554b9a29666b556f0bae8520430e73244abfbfcbbd72"
    sha256 cellar: :any,                 catalina:       "7a373d3e50a22619466b27bfad1576df98e2bae34433f5bf2d8ae370e2858e87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e7f4005c34030d2c8902fee844ff96ac8acd45d368c7cf28ba7c682fcc97ac5"
  end

  head do
    url "https://github.com/FrodeSolheim/fs-uae.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glew"
  depends_on "glib"
  depends_on "libmpeg2"
  depends_on "libpng"
  depends_on "sdl2"

  uses_from_macos "zip"

  on_linux do
    depends_on "openal-soft"
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    mkdir "gen"
    system "make"
    system "make", "install"

    # Remove unnecessary files
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"mime").rmtree
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
