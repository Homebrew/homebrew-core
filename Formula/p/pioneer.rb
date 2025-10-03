class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/refs/tags/20250501.tar.gz"
  sha256 "959902d98a79536bd44f25bd7b29e48da94aeac597228776b0f91635877f362e"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/pioneerspacesim/pioneer.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "108e3d19d6b670ac092545116b6a9d33464edd8a37c517a3dcc424331f28b527"
    sha256                               arm64_sequoia: "574d8bbe6db0b59bc597150357e398b585d43a73fc0d42caa35065431940bdf3"
    sha256                               arm64_sonoma:  "1435e6d5b33fa91933bf3fd78dc18bb77e049865b30cc39c2e2b69d09d6c258e"
    sha256                               arm64_ventura: "ae2dc446aff1982e591b87bfe6ba1f299d1a3d086efe948838a1af08e8adb0f1"
    sha256                               sonoma:        "63abc82602c824bc4e5e481ca5614903adc120b7a4e4df580e37ca3d6a0b7366"
    sha256                               ventura:       "7cae2e2ac52da2fbf163cc15c9d4e0b1f20e698eb084cd7ce29be948d3c313a5"
    sha256                               arm64_linux:   "551fc6bc1f0ac03a7b11e03b9b39e0a9e17dcc6ce3e11b4bf83a4b819e8cbdb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c6ab627311d3943bdafbde7f773e0fff0257267ae95753b4d720ed309fc2423"
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
