class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20200203.tar.gz"
  sha256 "3055d63c1bd3377c3794eee830a8adbd650b178bad9e927531e38cb5d5838694"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "8a14fbb626e9c17ca2dbaf97133783bf3877d1630110435fe7a90d4b4d3ee862" => :catalina
    sha256 "50c68ba522b25f82e96f068d1d754a8ce238649f213564b4ba4082527d0b1072" => :mojave
    sha256 "872703cd84bd69164f70f77e15768a57cb4b213a16e4b0f918947d24faaae911" => :high_sierra
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
