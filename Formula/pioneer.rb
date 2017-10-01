class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20171001.tar.gz"
  sha256 "154118bd3dac2f9b8ea43a837bcb967abcc8c3a8ee5ab61d35183bae85e8b0db"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "b892fefb8e2d5bb0b6a729143183cd904828570f240b25b2a9631116be5223ab" => :high_sierra
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
