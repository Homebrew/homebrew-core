class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20200203.tar.gz"
  sha256 "3055d63c1bd3377c3794eee830a8adbd650b178bad9e927531e38cb5d5838694"
  license "GPL-3.0"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "d6ef58a82bd5d0030f28db39103882a4da8416ba3b1dae5d3e98d09e2d06c5c6" => :catalina
    sha256 "837ce3dc518de05e3c50597252acf888b55ee341777f765bd4b1d88faf53592d" => :mojave
    sha256 "2d2d2aaeff7ec2231f7908504d4750f9fc2e60fd4d68f059d20808cea36370d7" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "libsigc++@2"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    ENV.cxx11

    # Set PROJECT_VERSION to be the date of release, not the build date
    inreplace "CMakeLists.txt", "string(TIMESTAMP PROJECT_VERSION \"\%Y\%m\%d\")", "set(PROJECT_VERSION #{version})"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "#{name} #{version}", shell_output("#{bin}/pioneer -v 2>&1").chomp
    assert_match "modelcompiler #{version}", shell_output("#{bin}/modelcompiler -v 2>&1").chomp
  end
end
