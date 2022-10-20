class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20220203.tar.gz"
  sha256 "415b55bab7f011f7244348428e13006fa67a926b9be71f2c4ad24e92cfeb051c"
  license "GPL-3.0-only"
  head "https://github.com/pioneerspacesim/pioneer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "b2e190f79505cc823854dcb3c46b333994fb15f065e95dc77934d4b27119aa8d"
    sha256 arm64_big_sur:  "0ca5b9a984198c3e3d60e3e02c8f3ccc046d2082900627a9bf970610c6260d95"
    sha256 monterey:       "0bb70eb1bb53b649bafb3ae3a52d4743fdaf690274a3e9ee0288e03fc26bc427"
    sha256 big_sur:        "310a48a34c8a19d9cb66bb7aa4f9a231d4519f636cfe1f3f2ecc219236ddbf1f"
    sha256 catalina:       "9b4bf989c69c7d9c24093aa728351b2558ccaf3770891c65f3c8d28da9778bfa"
    sha256 x86_64_linux:   "35b337ad69a13c8be0a0dc16281be604220cc3d26b247fdf90947ce51c93675a"
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

  fails_with gcc: "5"

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
