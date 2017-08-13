class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20170813.tar.gz"
  sha256 "9a2feec5236f8ca6ee8f0d75bccdee7bf6ae62f7a08b9e37cdd178642fdd32f3"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "ca72f0ff2e8cdb6308d0d515b2216176df481b02ff3b8425ff150631c64762a3" => :sierra
    sha256 "a049a255c887256ae5a69b7b21b69277c061726fbcafe0fdcf39c0f282805a2c" => :el_capitan
    sha256 "5d526df28022c9531c41ae60c704362831cc0fc6879e819a8c49b78e2ee7327f" => :yosemite
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
