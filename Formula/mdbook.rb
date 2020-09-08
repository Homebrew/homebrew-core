class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.3.tar.gz"
  sha256 "e1a60eb877a95c6cf8832cb158a8f09b2d641206fe853378905bcdb962902935"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e10027434f45b13179825378305913e16fdf8800026e01cd5ed9da26ea648c6" => :catalina
    sha256 "5be313962a7376089a10cb705610cc510c45403861c12dea6f4cef360ad09aee" => :mojave
    sha256 "e5fa3ed29d1f71112f5415c6a563a62d1dcef20af7c36e9a309d3877feed6005" => :high_sierra
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
