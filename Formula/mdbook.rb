class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.1.tar.gz"
  sha256 "48ee2d7102b440dbdb5ecb0849e82368a57777b03f3d6750ac7c47157b1da7ac"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a822942e2647a25e1068e1df41db825e87855fefc8ee252877e6246ac6e48c3" => :catalina
    sha256 "569f3329feb1626abf44d3cc714ef44f0e5645edfe08b9de01d85ea299883384" => :mojave
    sha256 "801437766049bdce1aa45cc5dc1f3d24949020dd83168b109b0407533dade2fd" => :high_sierra
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
