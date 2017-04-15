class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20170415.tar.gz"
  sha256 "dfbcfb63686fa3b7a16a4bac34de81adb02eeaf23593b3e63cca906bf4dbef67"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "5b6c7080ff1238f66496d53790f74f8edaedae1581d21288f850c2a242b4a55b" => :sierra
    sha256 "da8d22eea21ecaff5d987d0f8fd3f729c85b9691b60c53c87972c2ae0fab3b7f" => :el_capitan
    sha256 "5499c7f227728d60e2f352aae183f3387b1ff5d2735aa0103193d4ddc4e26192" => :yosemite
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
