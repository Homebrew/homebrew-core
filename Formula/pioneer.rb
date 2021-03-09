class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20210203.tar.gz"
  sha256 "fcbc57374123b44161e9d15d97bd950255f654a222840894f50bfc2be716ea68"
  license "GPL-3.0"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 arm64_big_sur: "a3151605aa2a2b4a8a5ac8266105d2293a7f06f594791fed4629340b8f819a71"
    sha256 big_sur:       "8b59ff2ff180ccdd5485d063d8a46038bc7ae2fb77c70a9a6aec891aba40c7b7"
    sha256 catalina:      "abeb86c374fa69e433e548cd1189105206cfd3859a1dd06d0ea2b45a15092b9f"
    sha256 mojave:        "bd448dc95f9f104637263a4e9aea398177b502938a969b766db8229ddc89860a"
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
