class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/20220203.tar.gz"
  sha256 "415b55bab7f011f7244348428e13006fa67a926b9be71f2c4ad24e92cfeb051c"
  license "GPL-3.0-only"
  head "https://github.com/pioneerspacesim/pioneer.git", branch: "master"

  bottle do
    sha256 arm64_monterey: "5577df2b19b517a48ee396f4845017b72ea189d5df6438f8386c81a1f4e33432"
    sha256 arm64_big_sur:  "706079cb77f9fe77b3e93898d898891b7469b9a7e27cb69122d251c0b947df42"
    sha256 monterey:       "b73fcfc1fe6b1c8976ed07b8ac0e82a390d972854483b2503437c04653a3dc95"
    sha256 big_sur:        "f725756669261a1fee10c39fec3a79bdbe4a4aaed5bbcb4680d2cf3de86241ef"
    sha256 catalina:       "45938119b01299002a7152f09472dc89afeba39473af90eb03b155c6b6b469f3"
    sha256 x86_64_linux:   "b6d87d20060bd57eceeb841acb953d726765b7d995e33694d1e059e414b97d05"
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

  on_linux do
    depends_on "gcc"
  end

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
