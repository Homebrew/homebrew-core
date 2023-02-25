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
    sha256 cellar: :any,                 arm64_ventura:  "5520123f90ac2fb54c6d913c49a81be30b1b4693c07d44b8f31054ef68fd00bf"
    sha256 cellar: :any,                 arm64_monterey: "53839933b9d639a09762a2139d14958aab9892893945d9acf982875c9f50ed5f"
    sha256 cellar: :any,                 arm64_big_sur:  "ff84b656ee0935b3138bfb6e824540b61f90f4e84be50c93270a84b1817a9628"
    sha256 cellar: :any,                 ventura:        "3b12971a7e142caab9b768f70eb9acd3146c93398e59b95ca63da04f31140951"
    sha256 cellar: :any,                 monterey:       "fb0dda69a580be48d9e5dc6fc303f7458e7da71789ae702ae0dc3e57b9d442aa"
    sha256 cellar: :any,                 big_sur:        "fbfce89fa2745424375d0de29daac696add8cd2bd9adafcd49b81c9fdc4b520b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "163f8e9b98598500d3d4e70c6e2214413be075004ec4386d6311bc17b89479ec"
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
