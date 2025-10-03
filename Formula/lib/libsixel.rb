class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/sixel"
  url "https://github.com/libsixel/libsixel/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "b6654928bd423f92e6da39eb1f40f10000ae2cc6247247fc1882dcff6acbdfc8"
  license "MIT"
  head "https://github.com/libsixel/libsixel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6de5ac481b343617fb5a42b78ca935b32758394e101ac8bfe6bf5f2828a991a3"
    sha256 cellar: :any,                 arm64_sequoia: "88cbe981c41523b73f930f4016f998766c0cea0c208f7689c784dcfd81fc76fa"
    sha256 cellar: :any,                 arm64_sonoma:  "dc6b0e6415de00ff5a57eb6feb5010418cd3d6550b6203daa32a812404d0124c"
    sha256 cellar: :any,                 arm64_ventura: "08aa4abca3775c48d84eba8ce64e94ce4f82dfc115f54b7db1125cb38f0d7bfa"
    sha256 cellar: :any,                 sonoma:        "85f135277174340376fb0e6ba6de5804bc017380224411f4ffca4956c6b4512c"
    sha256 cellar: :any,                 ventura:       "65e7a29a633dafc3306065c4fea861cedf9a51122f9aa22c3abfd8e3e664547b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93f446a2e99e9751229ad41532799e0f4c40983088c6dd47d026c80270f74541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afac541b74c1f46fea3c1e2b2c2443e93d769d221d3e512ef9af2a5ce2b292e4"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "meson", "setup", "build", "-Dgdk-pixbuf2=disabled", "-Dtests=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    fixture = test_fixtures("test.png")
    system bin/"img2sixel", fixture
  end
end
