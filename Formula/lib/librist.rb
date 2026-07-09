class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.18/librist-v0.2.18.tar.gz"
  sha256 "9a2d16dcdb9fb067b7ba4259a3976ff6f8df9a62dbec7f32f19a0b60ec0c114a"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "be4a67893095c87d73628c4d9f3587c73bf793430f6aeb445e7c46b8040dd5e5"
    sha256 cellar: :any, arm64_sequoia: "0befdedc19c37849ec129514c4dcbc26e839696895c665c88ffaa787caf46aeb"
    sha256 cellar: :any, arm64_sonoma:  "848b4ce7b472952f3cb469e72e4b42988a3aef546878e26321160b5cfa5e7c1e"
    sha256 cellar: :any, sonoma:        "f53d7747637e06716712cd427ca5530c5b57025b9bfd487559c45eb43f5471fe"
    sha256               arm64_linux:   "10a21b4a0a9c5ca957196faed37c411f346fd613c9bb051dc3565d88100e9473"
    sha256               x86_64_linux:  "556ab49bbde1dd93ae1e2842d2c101d3268aea2082a1dbbc85e5bb109ff6ce69"
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
