class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.12.2.tar.gz"
  sha256 "daaeefd21d8328282d2c1082faddbc1f4870c60c1453e6e85e1a421aa77738d6"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "241c6d9928465d33cf91c8c704a07d9b1da5c4836773e3fc3d044c67d68cc788"
    sha256 cellar: :any,                 arm64_monterey: "366cbf286f39497de764e0cbb5e15295e9d579c64af565fc2be3eacfd4b65cdb"
    sha256 cellar: :any,                 arm64_big_sur:  "d819e23d2c30a92eb809f7ae8831ac0290b6e74c2fa2aa296108c64a7e38de95"
    sha256 cellar: :any,                 ventura:        "d0d92370ea89d281fe10d0717b226407f31184faf7ee944ce87e2f6054a414e0"
    sha256 cellar: :any,                 monterey:       "8df2267b7fa3203ed573e7660d37140045bce5dbbe6e8261b2f09b803f492ed5"
    sha256 cellar: :any,                 big_sur:        "afefc72dcb0d3e8223c2a1df12bf38b730d9b169de34f45bc6b706ed9c2d77d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4bb51932f9e4a6c37f974a01724620a0d99eec8354536ff78bd0f6afe85e0fb"
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
