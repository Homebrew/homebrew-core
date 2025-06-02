class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/refs/tags/20250501.tar.gz"
  sha256 "959902d98a79536bd44f25bd7b29e48da94aeac597228776b0f91635877f362e"
  license "GPL-3.0-only"
  head "https://github.com/pioneerspacesim/pioneer.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "3f0963e3b117f8b462cd62d28d0d4d6508d3a3cb72a71f23049f938ce5df6a2c"
    sha256                               arm64_sonoma:  "9b016db2cf4b55cf30719eebdada5c22714e2cff5e0af527f22396a189127ce1"
    sha256                               arm64_ventura: "6395cbe506ea3c1ce1df39cbde8bdd182e8283611befd8ee8669ee6c9c4cbc82"
    sha256                               sonoma:        "b8db4414b2f2075a425ad8db7d8fbe1e2bcb62ad053c4b8bd28b02a43f0f784c"
    sha256                               ventura:       "2ba87a5173d1a17393017efa27b5c7c3b28f9ab3d5e7c493ce25e45507c88395"
    sha256                               arm64_linux:   "5392c601ef313258e8c2d24fe0cec56462216610a32993f951982e5b6e9700d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab19f4af575a7c78812be7530e593d02a1bd931db8f320153de1ecb94ed51f56"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

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

  # patch to fix `pi_lua_generic_push` call, upstream pr ref, https://github.com/pioneerspacesim/pioneer/pull/6000
  patch do
    url "https://github.com/pioneerspacesim/pioneer/commit/9293a5f84584d7dd10699c64f28647a576ca059b.patch?full_index=1"
    sha256 "c93e0f8745d9e1dc7989a0051489be7825df452e0d1fa0cf654038f1486e2f9f"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "pioneer #{version}", shell_output("#{bin}/pioneer -v 2>&1").chomp
    assert_match "modelcompiler #{version}", shell_output("#{bin}/modelcompiler -v 2>&1").chomp
  end
end
