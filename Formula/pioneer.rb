class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20170415.tar.gz"
  sha256 "dfbcfb63686fa3b7a16a4bac34de81adb02eeaf23593b3e63cca906bf4dbef67"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "be08d9da7f42080a39701421e4a4fbed39169af0ef67a91aad9ed7f699fac878" => :sierra
    sha256 "162b59e4b89c7b6ef8d3b0d7511f2b4fc714000d67c9e9536ca8602ef15d73f9" => :el_capitan
    sha256 "e40c216569efbdc5fd7224dca832d3006aa3f2319970d077b80b78bc9eb9b32f" => :yosemite
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
