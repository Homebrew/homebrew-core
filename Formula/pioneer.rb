class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20191009.tar.gz"
  sha256 "54ffa99b5dad6334e75f21deab6e9afa48164d5ea474753c6ccda1a742c22cd6"
  head "https://github.com/pioneerspacesim/pioneer.git"

  bottle do
    sha256 "7c0182c31a24c82eb17699d1903dc8ef5b099c129d6a98872781fc80d72de113" => :catalina
    sha256 "d8673a04707cb545d4fcbc8d8e6b7343d9ad0875e81eff084122f228407fcd08" => :mojave
    sha256 "7dd936ed8baf6cb85941ba23bf8845192c737fd05c585459746ff69c0cd27aa4" => :high_sierra
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
