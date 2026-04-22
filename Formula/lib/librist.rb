class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.13/librist-v0.2.13.tar.gz"
  sha256 "84b7f9228b2e9f3f484cc3989faed037c423581971bddde28370f6e6f5a0e90e"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "95b679ca348f386a2663b59ac5b5f22baa17023cbf841f1e0657cadccad002fa"
    sha256 cellar: :any, arm64_sequoia: "b3e891f094b3e28d1c0e0833010482bc4cfb779741149f351eb122e8f7178c9b"
    sha256 cellar: :any, arm64_sonoma:  "20788c18af2ca20933f8882e8e5e3943c55dd887d0ef360507de9d03c34e02ef"
    sha256 cellar: :any, sonoma:        "d906424dbf541252137c4ad32685c22215d47ed1ef0eef7797fc56f4893f4b82"
    sha256               arm64_linux:   "143dda342d34d459ab2cf304097f867e99e8dcca0b6e730e006ccb7e80e5b6e1"
    sha256               x86_64_linux:  "444fa81eb62dcfbd0c382ea141041f1ec5dcc2eebecbbe583437634270f11b23"
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
