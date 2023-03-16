class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.10.3.tar.gz"
  sha256 "5ba367f9d9f144d1e489c2393930b0eddfae7a8fcc732be22aabd66bb8b2fc62"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2bff5cc701dcab0998ac5faa2d188098d260e065883a642f70b86acc8faed0c6"
    sha256 cellar: :any,                 arm64_monterey: "6365d6386b896f732e65c0bade8e05c9e8fe9b6b2498595e15cbd8b92598067b"
    sha256 cellar: :any,                 arm64_big_sur:  "ad1fff271c9c7ffe684243c4fdf9572a51291faa53283d4916225af2fc62f251"
    sha256 cellar: :any,                 ventura:        "c7dc1fa5f1ce84fdf50662558d5363cc7bf2c46f359df39ee55c1e490733ab58"
    sha256 cellar: :any,                 monterey:       "2f866f1ba36dcb6ba87b40e14d8f864283f4e5fea5dedea7ad42e09708c14c90"
    sha256 cellar: :any,                 big_sur:        "421ae4ed99a0c7bfc07a673f83027380a50d61c586efc30d271b93e65afba3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9902c36327e0cc159fd8334dbc432088a95f11ec2f44d5cb49fa59186803196d"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@4" # FFmpeg 5 issue: https://github.com/ImageOptim/gifski/issues/242

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
