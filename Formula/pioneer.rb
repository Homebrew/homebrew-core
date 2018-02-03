class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20180203.tar.gz"
  sha256 "19aa89e8ec0221b937b9279e0d4897b3016e0ce80858d03600d3e80cd7daa907"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "65265e875bbc35e9e90f7fa30593b21c32f4c014c8a4682ea2e9c6c9319ff671" => :high_sierra
    sha256 "92d9c019e5073d48a0394258e1b0f5685797a0aa2a696b485500562a98560928" => :sierra
    sha256 "8a459fcca3bdcd04caaae6c3613ad0dd351ad535a7b6b4f2359a3b58ed382abf" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "freetype"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "libsigc++"
  depends_on "libvorbis"
  depends_on "libpng"

  needs :cxx11

  def install
    ENV.cxx11
    ENV["PIONEER_DATA_DIR"] = "#{pkgshare}/data"

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-version=#{version}"
    system "make", "install"
  end

  test do
    assert_equal "#{name} #{version}", shell_output("#{bin}/pioneer -v 2>&1").chomp
    assert_equal "modelcompiler #{version}", shell_output("#{bin}/modelcompiler -v 2>&1").chomp
  end
end
