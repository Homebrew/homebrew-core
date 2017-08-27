class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20170827.tar.gz"
  sha256 "e9dc65a0d21c8b4417b47054ebbd5661a5db43790d7868c66bbcd63b30cb8bd1"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "475414dd65670108dcee1a2769bb24e2c7525b2bbe5b1f2188c3c3585983f5b2" => :sierra
    sha256 "8f2c5e0ea5e1818d5db21acc89dac68319549b48983d8e4499cc09c89620b9d6" => :el_capitan
    sha256 "88a33dc31193229a8229b7fa40c49d58b805744d7177b2524ab99509bc81fa1f" => :yosemite
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
