class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang-nursery.github.io/mdBook"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.1.tar.gz"
  sha256 "8852c12bb80c9c4ce82eaa5edb9036b739ceb65d5cc0ad1ff48147369f3829ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0a2ec6304a160d958db04db5656deb0e2425ac939e351791a0b11c8365fcda2" => :mojave
    sha256 "62dfb80f5e987cf08e10b392b3d231e521da66ed67146ac305d71522b6cc7ff7" => :high_sierra
    sha256 "9a5389bd6221d42ed9870ebb1a207983fb1472c384e47be92b3e1ed133fcaf29" => :sierra
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
