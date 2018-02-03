class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20180203.tar.gz"
  sha256 "19aa89e8ec0221b937b9279e0d4897b3016e0ce80858d03600d3e80cd7daa907"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "fe7123f2a61de3bc5a367fbad1f1a61d554c59e3526e7d79e319fefb46d977d3" => :high_sierra
    sha256 "24482bf17e5d4294e760a121e93949aa8c2bf6930629995f8693d23a549f13ca" => :sierra
    sha256 "eb188ce5b4aff9025a664e4276f64fba3521b581eb1f13df610b83ae924ddf5d" => :el_capitan
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
