class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.7/librist-v0.2.7.tar.gz"
  sha256 "7e2507fdef7b57c87b461d0f2515771b70699a02c8675b51785a73400b3c53a1"
  license "BSD-2-Clause"
  revision 2
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "c84d3d82e2b686d1080057b8b2ffdceef533450a2d333a7ad96fd09821c86d65"
    sha256 cellar: :any,                 arm64_monterey: "9d5d45744c957c4a1973a06da466ab59e3fa2676392e9592ad481fff3e33582f"
    sha256 cellar: :any,                 arm64_big_sur:  "81326291534f2f962b20bb92b0c965a6bb9c7236e527c94fa1f0745bcc20ddc1"
    sha256 cellar: :any,                 ventura:        "a5f11286aa78d1c261eb3700373962518897c58b2d582c22adb29a0a48ad49a7"
    sha256 cellar: :any,                 monterey:       "3135e6270bce813c0e9a0bb57ee5cad36e9e3cc9eca9e054ad39fec514a3455b"
    sha256 cellar: :any,                 big_sur:        "0600f9e6f807d2459ffda00135c03029de73080a2756ec414f9d22c03c9a62ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b469974821febbe2b62d6ec62efdabf9c76ad1186c6670df7983afb81aab97c6"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cjson"
  depends_on "mbedtls"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"

    system "meson", "setup", "--default-library", "both", "-Dfallback_builtin=false", *std_meson_args, "build", "."
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end
