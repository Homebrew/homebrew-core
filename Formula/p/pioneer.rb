class Pioneer < Formula
  desc "Game of lonely space adventure"
  homepage "https://pioneerspacesim.net/"
  url "https://github.com/pioneerspacesim/pioneer/archive/refs/tags/20250203.tar.gz"
  sha256 "5b2814ad63b9b7f995fd6a1b913f97d00b450663d07cfbae59c88cccb97d5604"
  license "GPL-3.0-only"
  head "https://github.com/pioneerspacesim/pioneer.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "ec66807324da4c6f218071ce72ce492982e7c227a0c0e1911ad1a545549ac537"
    sha256                               arm64_sonoma:  "cfd35a8fa9e1f5002fdf1744c6a63ff00e9697fdf6a8b4ce44e2a0d99bdf8b80"
    sha256                               arm64_ventura: "ef19b8336cd0a91224b95f59d197483feb1f5b1aed366505b507c3b883de733b"
    sha256                               sonoma:        "7638fd5bf5629ea22a841cad157019fa6881b22887ce35c63a7210fc0118a99e"
    sha256                               ventura:       "0d454aa25ff8daf19ed076b08fe60c17a369c8d02ef6df5fbcf43cd6667e6229"
    sha256                               arm64_linux:   "fb81bed6156535cdf0b91155ac24fe0b306657e2cd0c909f75de1345b150ea25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a5608bea6d7026c0d36797cdf8fcb73b4679e319300dbc2feb75ffed6f641b6"
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
