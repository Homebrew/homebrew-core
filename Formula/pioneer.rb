class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "http://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20161129.tar.gz"
  sha256 "1c6fcc9a16da2c6d664ab88764718b94d7fdf5016bc5b4f97d7b00f8eccd9336"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "8ef309b2aeddfc4c8e1ed33f288f2032b43e522777b8e5946e5ab219621295ef" => :sierra
    sha256 "fd9aae49b26b9f87876c99c2e802bd63f224110934094ef2e14e5222519a0fe9" => :el_capitan
    sha256 "4592cec47cf52f22f9c779b3980c93f67056f318489933381e9262fdd9d2edcf" => :yosemite
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
