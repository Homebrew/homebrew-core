class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20190203.tar.gz"
  sha256 "e526f1659ae321f45b997c0245acecbf9c4cf2122b025ab8db1090f1b9804f5e"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "23947d453a46d35df0f9c6fb2e1adcc2b7c617715ff1c511bebd506e2917debf" => :mojave
    sha256 "4c486039882c875eef6efd1eaaeec11c38ae9e689e3ccce62c9aedf94788cdf9" => :high_sierra
    sha256 "5369b0bd037db606cb9ee7915f84c91fc225f1315d554292c9c11a34e8363e3a" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "assimp"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "libsigc++"
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
