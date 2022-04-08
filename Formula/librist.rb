class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.7/librist-v0.2.7.tar.gz"
  sha256 "7e2507fdef7b57c87b461d0f2515771b70699a02c8675b51785a73400b3c53a1"
  license "BSD-2-Clause"
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "401d0c3cde4ce87ba50676c7235ff523540906436a16fb8194d7cf52a942e2d6"
    sha256 cellar: :any,                 arm64_big_sur:  "9d822e2949f0db5e4127008c166026bfb2be021219dec45bcb0f48ef3c1724ad"
    sha256 cellar: :any,                 monterey:       "459881be00dd1e4ab5f0c26fe876d9436fff26331aee9b6cd9c3a9f461ec41f3"
    sha256 cellar: :any,                 big_sur:        "611f5337f0af96982bfa6248d812854019397f23aeff9989332d13b1f7548883"
    sha256 cellar: :any,                 catalina:       "3dfe38c829c8b88b5af0d1180e644afa7ae1c560b0a3d3eedec86eafa793221b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "489462998d673e7f21a2d3b3195435d4d72b23c0badd33df21f46e5a8eb3de07"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cjson"
  depends_on "cmocka"
  depends_on "mbedtls"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    system "meson", *std_meson_args, "build", ".", "--default-library", "both"
    system "ninja", "install", "-C", "build"
  end

  test do
    assert_match "Starting ristsender", shell_output("#{bin}/ristsender 2>&1", 1)
  end
end
