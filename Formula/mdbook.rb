class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang-nursery.github.io/mdBook"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.1.tar.gz"
  sha256 "8852c12bb80c9c4ce82eaa5edb9036b739ceb65d5cc0ad1ff48147369f3829ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "40279d716232e2cc93b251b0a89be24322cdc8168379ea74650cf03c47c9204b" => :mojave
    sha256 "bf10c7e208cffda8c992007b9743e439fb91d690ece5ae86d62da5db056cd31c" => :high_sierra
    sha256 "793d23bd8415a9cc0ebbcb33c8b08c243ccd76c17684b008e838accc22e21198" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end
