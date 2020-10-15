class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.3.tar.gz"
  sha256 "e1a60eb877a95c6cf8832cb158a8f09b2d641206fe853378905bcdb962902935"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e931b5af1251e4915bc382f28befc9434b8a98b5719a8c4a6f5a8dd6bf0eea1e" => :catalina
    sha256 "77d58b70d13451053bb75f61f289a33c2655dadbd4ae3d9d87e44e219bf2694c" => :mojave
    sha256 "2d9825839cf12079c9003888a45635c48531e34feffe656ef95ce399f189b33f" => :high_sierra
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
