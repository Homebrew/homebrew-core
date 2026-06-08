class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/refs/tags/20260203.tar.gz"
  sha256 "861341d317fc0ca506e3a2e8ff00858983652a5656289f8fe9ad1525df1a95da"
  license "GPL-3.0-only"
  head "https://github.com/pioneerspacesim/pioneer.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "7ae2eb5796a4910a15bd829f3fddf5ca9cd053f5728c3efbc2685642ed13b5b6"
    sha256                               arm64_sequoia: "2f97087249fb0ccdcc983976fb150d993c7294d4f9b8f2e671c3cfa60c6d8f5c"
    sha256                               arm64_sonoma:  "eed62b8b5d57fade0b62887098331c09e8d04a2b37ada2ea6dfef6c499acbac4"
    sha256                               sonoma:        "7f1425f262ba4e222d0e28249b560a910011bb6ee3c2ae0c4ccb799dd063328f"
    sha256                               arm64_linux:   "23bf36101661131d354b456e8258be52a359a53c3d4ca80941d7719bb2e00102"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70ae3174bf568ea87f9a65dfb766b246e66ff09529bc30724d79c34760c91ee1"
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

  # patch to fix ambiguous `to_string` overloads
  patch do
    on_macos do
      url "https://github.com/pioneerspacesim/pioneer/commit/24023dfa75b1bd9de15b45692aeedab26da1b1b7.patch?full_index=1"
      sha256 "9279afa54507c971ea517f508c1796b0ce9dc435d976778d13bfea7813056908"
    end
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
