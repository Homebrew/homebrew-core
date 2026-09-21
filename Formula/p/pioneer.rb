class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/refs/tags/20260907.tar.gz"
  sha256 "11d1fbf745f5fc710f30cce02065b60e5aeb05f7c79b2cfdde8b4c64ec132491"
  license "GPL-3.0-only"
  head "https://github.com/pioneerspacesim/pioneer.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "4618b894ef9009b16852efbaea32fe16f5d827629f2250c29f5ea930384edf3f"
    sha256               arm64_tahoe:       "666658cae770ddce6be9ece3bfab9b81b8ac10d7313c2aa0264a985a72464d88"
    sha256               arm64_sequoia:     "71f8e39d812de5956684d8bf6bab1e4aab294d1aef291ee25ec9c8251917421a"
    sha256               arm64_sonoma:      "64c3f414b2e1f8e808483dff8e5595b7f8d359f05e5cf5de10e157bdf19379b2"
    sha256               arm64_linux:       "476d07b36090731867426a35d88a9b0c45bf7499faccfa8e66fa1a082fd5c620"
    sha256 cellar: :any, x86_64_linux:      "3ebe21380f7ca7181dafa32b25e8f4d889d6bd361acafb3ab1ce0fc679265d09"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "assimp"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "libsigc++@2"
  depends_on "libvorbis"
  depends_on "openal-soft"
  depends_on "sdl2-compat"
  depends_on "sdl2_image"

  on_linux do
    depends_on "mesa"
  end

  # patch to fix ambiguous `to_string` overloads
  patch do
    on_macos do
      url "https://github.com/pioneerspacesim/pioneer/commit/24023dfa75b1bd9de15b45692aeedab26da1b1b7.patch?full_index=1"
      sha256 "9279afa54507c971ea517f508c1796b0ce9dc435d976778d13bfea7813056908"
      type :unofficial
      resolves "https://github.com/pioneerspacesim/pioneer/pull/6286"
    end
  end

  # patch to fix `pi_lua_generic_push` call
  patch do
    url "https://github.com/pioneerspacesim/pioneer/commit/9293a5f84584d7dd10699c64f28647a576ca059b.patch?full_index=1"
    sha256 "c93e0f8745d9e1dc7989a0051489be7825df452e0d1fa0cf654038f1486e2f9f"
    type :unofficial
    resolves "https://github.com/pioneerspacesim/pioneer/pull/6000"
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
