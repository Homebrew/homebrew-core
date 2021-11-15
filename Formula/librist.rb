class Librist < Formula
  desc "Reliable Internet Stream Transport (RIST)"
  homepage "https://code.videolan.org/rist/"
  url "https://code.videolan.org/rist/librist/-/archive/v0.2.6/librist-v0.2.6.tar.gz"
  sha256 "88b35b86af1ef3d306f33674f2d9511a27d3ff4ec76f20d3a3b3273b79a4521d"
  license "BSD-2-Clause"
  head "https://code.videolan.org/rist/librist.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a49ba8240dce8d368b193a8d6388553b1688f09eb698891fe059c52829d941b9"
    sha256 cellar: :any,                 arm64_big_sur:  "33edba89ab01a727ae17d5c76742a20e61030c0dc5b46c5063a07fd31ec16214"
    sha256 cellar: :any,                 monterey:       "9b5c174610b58707c25b27c9f9ef5cac947e928cc3a1f7d80789648c5c3d0dc5"
    sha256 cellar: :any,                 big_sur:        "32ca4949e0b34daff4eac02cef3fc018a08a29b531a16c5199c5549317292b84"
    sha256 cellar: :any,                 catalina:       "a78e9af5a97225aa3caf5f3a700d819fd7ab011537f742fffc9ffa55ec8be035"
    sha256 cellar: :any,                 mojave:         "4a4e0782ae28a9832313a46cfc5af148b95c0f1760dca560baefd46bf537e828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d5676085eb79786f4165816df783eb0662e59a715432c1d5c5700b01b7ee95b"
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
