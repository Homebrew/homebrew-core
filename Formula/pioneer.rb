class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20170304.tar.gz"
  sha256 "45d448a5ac53c9e230522600f03dad7abc70788367d09c3edcb4ae4285050004"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "1ee88d6947ab3bb20898fce0e686a4c807ab0d97b8955b0437929a90aedbcc57" => :sierra
    sha256 "c9ad6ca3693934d10998d6186518b8fa8b137335a2093a6f4b3769e9e3f66c78" => :el_capitan
    sha256 "f3f80872e3e47925679a1583df1526efcfb74a51649d55b571b3237d84cc00a6" => :yosemite
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
  depends_on "lua"

  needs :cxx11

  def install
    ENV.cxx11
    ENV["PIONEER_DATA_DIR"] = "#{pkgshare}/data"

    # Remove as soon as possible
    # https://github.com/pioneerspacesim/pioneer/issues/3839
    ENV["ARFLAGS"] = "cru"

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-version=#{version}",
                          "--with-external-liblua"
    system "make", "install"
  end

  test do
    assert_equal "#{name} #{version}", shell_output("#{bin}/pioneer -v 2>&1").chomp
    assert_equal "modelcompiler #{version}", shell_output("#{bin}/modelcompiler -v 2>&1").chomp
  end
end
