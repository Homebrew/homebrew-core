class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.14.4.tar.gz"
  sha256 "7d6b1400833c31f6a24aac3a1b5d44c466e07f98af6d6c17487a7c8c6f4aa519"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4cd9f0178e0bf227c0e702c48fe108790922ffec6d87c40cb59add10f3e8aa2f"
    sha256 cellar: :any,                 arm64_ventura:  "bad32d338e851e3c2bd459b3c26b0e31fb7830d76211f0accdda70449547c2f7"
    sha256 cellar: :any,                 arm64_monterey: "051d96c3a000fa79be32741cbb194bd89ad08424fcd2dabf66598f33e782e2db"
    sha256 cellar: :any,                 sonoma:         "324ecf6366f9046fee2befad79d2a3bde580c1e342a52b8e2b367a561c4d35ba"
    sha256 cellar: :any,                 ventura:        "ae41654b042eb827c70227142dae889cf6d9e6773cb79f89331e9c21206a1b97"
    sha256 cellar: :any,                 monterey:       "5a8cc680c54eeaaddf0fb0526df1ab5a2deacf8a9c9f223dabbefeed2ce80ae3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc43456bf605740c39789127a737a9509e6a2629dca26c5ee6b73f3f4924705e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
