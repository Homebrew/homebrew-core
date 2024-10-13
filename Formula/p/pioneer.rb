class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/refs/tags/20230203.tar.gz"
  sha256 "80eea94e0f7e4d8e6a0c4629bdfb89201f82aae2f59ee7a1f7a487eeeccf27c7"
  license "GPL-3.0-only"
  head "https://github.com/pioneerspacesim/pioneer.git", branch: "master"

  bottle do
    sha256 arm64_sequoia:  "021f05a8f45ced0f1f7e6caf947157db8b253077670a23426ede21bd582ebea7"
    sha256 arm64_sonoma:   "f987336d46f0d5541dff2ef1aacfb20d632e2c345db9b4428f5e64155d2b9293"
    sha256 arm64_ventura:  "6629891c8f8f85d32796a2e984675b3a543d19b9bd17e86daa3001e108a6649f"
    sha256 arm64_monterey: "95f82fcc3dc1c3b12189ee417dda7ee2517bdc0bd850af9247b98dfa6e5c1e14"
    sha256 arm64_big_sur:  "759269a2e00d06d6cc09293f7ff41bbc53991fe44721a870b32bd771ab70d7c4"
    sha256 sonoma:         "37b3531dea6b2e03235635f55c623981b69fde07fe6ca53032c3405f0f66275c"
    sha256 ventura:        "de952238374b4bcebde412c5c02c06bc1390238136b9f5f987f73dd0125ca720"
    sha256 monterey:       "10abffe3e985ffcacd1709f6f1e1072bc8755d767e7c5fa3d6b7f2f3011f45d3"
    sha256 big_sur:        "805b22fbde064931335713adbc9b25142d508141b3a798779a777c08082be107"
    sha256 x86_64_linux:   "2af51910ed74e3ec2a4e79aadf489da5bf312b3f63a044d74528221dde1106f3"
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
    depends_on "mesa"
  end

  fails_with gcc: "5"

  def install
    # Set PROJECT_VERSION to be the date of release, not the build date
    inreplace "CMakeLists.txt", "string(TIMESTAMP PROJECT_VERSION \"%Y%m%d\")", "set(PROJECT_VERSION #{version})"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "#{name} #{version}", shell_output("#{bin}/pioneer -v 2>&1").chomp
    assert_match "modelcompiler #{version}", shell_output("#{bin}/modelcompiler -v 2>&1").chomp
  end
end
