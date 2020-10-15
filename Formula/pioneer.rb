class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20200203.tar.gz"
  sha256 "3055d63c1bd3377c3794eee830a8adbd650b178bad9e927531e38cb5d5838694"
  license "GPL-3.0"
  revision 1
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "dd740d3f1f48b444c2c4954621174f27bb5e58f0f337577fe17ca1e0bcc27ebf" => :catalina
    sha256 "e76632b5f3ffee2f88485a9dfdd55d6bb64566c5a78045a8d6e7e33fef254468" => :mojave
    sha256 "1485110ccb049479063b6a94cd1385e678251da599d3ef92ca99f8fc69a99000" => :high_sierra
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
