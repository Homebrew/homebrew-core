class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.14/librist-v0.2.14.tar.gz"
  sha256 "af227cbe2781f223aa7bab3332ddb1221fa3ee2fa8d493b58a40024f56c67292"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3d5a992bd4ad81d8efe05ad78c6a33111867c138d6770c8c52c924e84e188c88"
    sha256 cellar: :any, arm64_sequoia: "69ddadac76450cf7c36e7f4cf9e1a17014583dcbde39ac266e28e03373745de1"
    sha256 cellar: :any, arm64_sonoma:  "0652e0c0bbad0d63aede96c466de7f7e2a393755f92b68d3f6f55b9111bd7d5f"
    sha256 cellar: :any, sonoma:        "595967b9335190952a74584c3dd9c8642fb8b7dd3a3794cb2ba882227f2b0e92"
    sha256               arm64_linux:   "17e73179c3147a5dcf46fe2bd465bd7217184efa0c49abc00ad357b67126f948"
    sha256               x86_64_linux:  "13073d9b30b3ceead018e69a3403007f4d262adf1bfbcbe1d0d13a9e5ad690bc"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libmicrohttpd"
  depends_on "mbedtls@3"

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
