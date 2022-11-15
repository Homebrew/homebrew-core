class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.7/librist-v0.2.7.tar.gz"
  sha256 "7e2507fdef7b57c87b461d0f2515771b70699a02c8675b51785a73400b3c53a1"
  license "BSD-2-Clause"
  revision 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "265eefae9e0acee5320ec6d53c00e1ce0a6a2db438808db64f81ef908f5f1f40"
    sha256 cellar: :any,                 arm64_monterey: "05565a30880ee384c7d93fe794e9049ba26fa3defca0eeb2d404e92501a8bf32"
    sha256 cellar: :any,                 arm64_big_sur:  "cc67eb033dd721686532b5510f8cb491d6a34d1f61abdec3b37c793a7170d5b9"
    sha256 cellar: :any,                 ventura:        "c8788d4f4290cd71c0c820fda018f143391ebed8a4795141750ba39dd13d5de4"
    sha256 cellar: :any,                 monterey:       "aa1d34394b985cc887e1e29dac1ba66cf300f47e3c29a818d0e16278b7b92b1b"
    sha256 cellar: :any,                 big_sur:        "1236ff0ecd6cef12b1d75dafe96666ac2934f5a321b12f9bdb8f9cb42e742b9e"
    sha256 cellar: :any,                 catalina:       "46ea9a2c900a027285fb9f321664987491bc8703d22f92d9a5047fffb8c25f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2724f4e1c469f66420ba87918041ca6871c772249470a92a99fd195c4977b46"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "cjson"
  depends_on "cmocka"
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
