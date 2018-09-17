class FsUae < Formula
  desc "Amiga emulator"
  homepage "https://fs-uae.net/"
  url "https://fs-uae.net/stable/2.8.3/fs-uae-2.8.3.tar.gz"
  sha256 "e2d5414d07c8bd5b740716471183bc5516bec0ae2989449c3026374dc4b86292"

  bottle do
    cellar :any
    sha256 "8134b3078a0a74ee84a56fdf45063eca1a150820b30cc849e94254f879660c8f" => :mojave
    sha256 "c3248540860a5d3829087227e5e1145bf37727339c6b697441e35748253b2232" => :high_sierra
    sha256 "1bbdae6cb275764ebddbbb535095ec51677ce6566877961a60ed2e1b1d2f6471" => :sierra
    sha256 "7437962981be6a10ba6952a07746f0c9e8e165e1e6e647b2cf5fd9042ee89669" => :el_capitan
    sha256 "c0a2ef6dc723d726e70df915d5a0a8db200743290715acf80ea8fe0d3a344c65" => :yosemite
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
  depends_on "openal-soft" if MacOS.version <= :mavericks
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
