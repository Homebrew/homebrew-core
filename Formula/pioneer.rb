class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20210723.tar.gz"
  sha256 "5f5d794d3095079e629980a6a3285d83b95b97e6c9b6058c73531cd06f8d082d"
  license "GPL-3.0-only"
  head "https://github.com/pioneerspacesim/pioneer.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "cf660f08f7b18489c4a7fc5e5ff0f800f846886b48a0dcd78f6d7b3e6216a47a"
    sha256 arm64_big_sur:  "f81b47bad4f1c6cef0655b91da3c805735c75c3111495eba83bda3bc917ce3bb"
    sha256 monterey:       "dbb827cc837f5a275df362739ff2c2131050507f73c8026db06720fa4ea0d9d1"
    sha256 big_sur:        "dedb56a9bf9ed68885724b45c5ff371247d9e42acbf1376bdf283e1b2bb2f301"
    sha256 catalina:       "caf101b903a64522ee78327951b73b76499a110a9a32cea3ca1de699ff1e2574"
    sha256 mojave:         "713fe514265cdbb7ed9f4c21fea203ba479aea835c75ac34be191f901c06eb12"
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
