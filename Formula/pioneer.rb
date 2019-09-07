class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20190203.tar.gz"
  sha256 "e526f1659ae321f45b997c0245acecbf9c4cf2122b025ab8db1090f1b9804f5e"
  revision 1
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "84dc7f21bde81882c7846f8de0cd71465c26be88dc9bf523dd0c193d1b6cb47d" => :mojave
    sha256 "610de685a2de25fa7b56d0b4a342f4f0c1804d2d610a2dfa695bbcef35581856" => :high_sierra
    sha256 "a583feae2e73f15ba3e647d341ae488415ccf6494ba0d59575a55f414b235deb" => :sierra
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
