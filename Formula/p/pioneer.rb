class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/refs/tags/20240710.tar.gz"
  sha256 "65549552df84edaecf0c2547d01dec137282c9fe20a1299f9494b739c90ef7ed"
  license "GPL-3.0-only"
  head "https://github.com/pioneerspacesim/pioneer.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "47094faa61901883b86867f338971f2ae6f1ddd27de5cce9b9386f47561db222"
    sha256                               arm64_sonoma:  "2b2d1798ef9cacac6aae436bc1ebb9e99fb0ce64d5bab9a117c67b9abc329a69"
    sha256                               arm64_ventura: "35c406419857a82e18cede4a8820d226b0f0a83e7013a2b388529a48338fba3a"
    sha256                               sonoma:        "cbf97b200ffbea940d4fb5e6c6d7845b8f0c2830642a5ed60231075fbd157e10"
    sha256                               ventura:       "1c238e95d5c2ddc4477d0844cc4b21b2bbf871e274d0c88ad0b50b07f916c971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9b9014de6fef65eece99be722a6fdcc5636c2f26bee124fd42263ff0dc8c649"
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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "pioneer #{version}", shell_output("#{bin}/pioneer -v 2>&1").chomp
    assert_match "modelcompiler #{version}", shell_output("#{bin}/modelcompiler -v 2>&1").chomp
  end
end
