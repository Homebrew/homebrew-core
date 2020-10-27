class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.4.tar.gz"
  sha256 "eaf01085bd25e2efa07b561148afa5e3da3386e5f2c35b245961dc485562c154"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "59595db021b9ae3e8a2137f7c9deb740508cf110a3822f49715721d571870b1d" => :catalina
    sha256 "12bd9ff40b7421497209163efb1e802dd3ca08e5b84fe5f5c7446eae0366d291" => :mojave
    sha256 "0671b254178a018b1d5ce8e2d1a880886904ff93caebe3d0867a3a5423e35f6f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end
