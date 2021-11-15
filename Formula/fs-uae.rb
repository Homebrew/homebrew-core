class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/files/FS-UAE/Stable/3.1.47/fs-uae-3.1.47.tar.xz"
  sha256 "b9761b7f60068c8b7d4daa0f08efdfbaa0662901ac1aba9101964906bc558320"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://fs-uae.net/download"
    regex(/href=.*?fs-uae[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "89a9f14c2a751f08ebdf07bf73a6c2cd3ec4fd9a358c111efeed344b56201874"
    sha256 cellar: :any, arm64_big_sur:  "d6c6581044c46383f86c80ee5f86d572083440970295fed41568e378e0150aa0"
    sha256 cellar: :any, monterey:       "1d90387dcc15231beff9906234e1ff14ca7f9cad7f3deab69cea8f5cf80db6fd"
    sha256 cellar: :any, big_sur:        "df2a583a7fb939da7eba2cd2afb80e9248cd5517770d850a7fba5f7571f0b870"
    sha256 cellar: :any, catalina:       "d08995c604e6f420f43324ff1dc420dd4baef1f8bac063811555130990624871"
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
