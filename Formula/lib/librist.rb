class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.17/librist-v0.2.17.tar.gz"
  sha256 "2eb2ef89fc746088194dc7591fdabb4d753061b06f7074709edc375bc4d04467"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3e757fb8bfd436d79a5a93aca3578cb4ab08bdf79b08efcea15e9d17469a4399"
    sha256 cellar: :any, arm64_sequoia: "de9966e34a657fa5a75be713803b3a56c67f6f765157ffdc5c5852cf6d6b15c7"
    sha256 cellar: :any, arm64_sonoma:  "ca124839f0965435f50e116727f18fcc96508b68504cbd4bf078f27ffb574e76"
    sha256 cellar: :any, sonoma:        "63f4aca1f419cf4627bb64dfcba35ef210f64969c4a3314e1aba643f22ea8f60"
    sha256               arm64_linux:   "a6bc4e24985dbcc316f7f464528fd3e8b298aa28ea168fc25bae4c521d1f6850"
    sha256               x86_64_linux:  "a52308204431d216256dbd306bd9ca11b43728ffcc62bfe93bd9b7fa9b8e0d5a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cjson"
  depends_on "libmicrohttpd"
  depends_on "lz4"
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
