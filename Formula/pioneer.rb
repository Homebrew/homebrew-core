class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20171001.tar.gz"
  sha256 "154118bd3dac2f9b8ea43a837bcb967abcc8c3a8ee5ab61d35183bae85e8b0db"
  revision 1
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "8a6ba36e5a1a04c72fee3ef5921762108a6a7be7ba7b31c9dade6faa220f8c78" => :high_sierra
    sha256 "01e84d6dd7be3f2444df347ecfdf8bf34a02b7ac6627b7d18b2fe4e3b258f214" => :sierra
    sha256 "76430af8d72959d5f2ae2224c85456d57e397028bd48181a1f1de0d62bf60748" => :el_capitan
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
