class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.34.0.tar.gz"
  sha256 "c9711473615cb20d7754e8296621cdd95cc068cb04b640f391cd71f8787b692c"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e3c7358ae7bcc904cc67d92016abbe8f9861d2cec19f6cbf35110b36880bae7a"
    sha256 cellar: :any,                 arm64_sequoia: "4f666d7abb9833ab9fcbef4da60f84861e9e12a61eeaffbc2e78c63f601163b7"
    sha256 cellar: :any,                 arm64_sonoma:  "61d4c40ddadd5df8c3e98c26abd374d83d1a17a5c330072715c6127a290e6068"
    sha256 cellar: :any,                 sonoma:        "afc5d261245a11a2000c342c158eb948896a557028aa055bb078a46df3c4828f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "584afb5e1a1577e97688b89858c21d80d0e38822b373af5296473a870b58104f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8919e828c957d9b3d7e9c589c0398f49ddb8c84b057df791cb44e6499befcf05"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg"

  uses_from_macos "llvm" => :build

  # Apply Arch Linux patch to support FFmpeg 8. Also used by Alpine Linux.
  patch do
    url "https://gitlab.archlinux.org/archlinux/packaging/packages/gifski/-/raw/592ebed61803fb8eb86fa8b5e33caec854e60ddf/ffmpeg-8.patch"
    sha256 "ce67b34864c276a87b5e8324c06297d3c52bd8fd625fd38236d3473d23513039"
  end

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_path_exists testpath/"out.gif"
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
