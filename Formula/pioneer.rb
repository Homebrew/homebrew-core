class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20190203.tar.gz"
  sha256 "e526f1659ae321f45b997c0245acecbf9c4cf2122b025ab8db1090f1b9804f5e"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "2166f735db89aa995b06055b23e94592a00a634d9791524ddd2560d5ebc4bad9" => :mojave
    sha256 "fe7123f2a61de3bc5a367fbad1f1a61d554c59e3526e7d79e319fefb46d977d3" => :high_sierra
    sha256 "24482bf17e5d4294e760a121e93949aa8c2bf6930629995f8693d23a549f13ca" => :sierra
    sha256 "eb188ce5b4aff9025a664e4276f64fba3521b581eb1f13df610b83ae924ddf5d" => :el_capitan
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
