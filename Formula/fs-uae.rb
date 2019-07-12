class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/stable/3.0.0/fs-uae-3.0.0.tar.gz"
  sha256 "221568b8f78bac352f84297f0cabe984d3da4f808e39cc3191541c02b389c964"

  bottle do
    cellar :any
    sha256 "5ddcfa809beb6ef4d258e4d6d4a1267c60025b704ac3523db3d61e05ee3c1ee8" => :mojave
    sha256 "d63aff368e8d17cfd02c44d1cbd2c2be2edb1ab7cb5327bd0ebd4c952a79346e" => :high_sierra
    sha256 "c201942061b5281744df66c642636905d8f4e21f22bbf0f5a0748154cede99f1" => :sierra
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
  depends_on "openal-soft" if MacOS.version == :mavericks
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

    # Remove unncessary files
    (share/"applications").rmtree
    (share/"icons").rmtree
    (share/"mime").rmtree
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/fs-uae --version").chomp
  end
end
