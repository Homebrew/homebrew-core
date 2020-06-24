class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.4.0.tar.gz"
  sha256 "402439a3ce61415bb84f0bf7681e15c96a9ce627c9e2c08647ec8c557c1a9b1a"

  bottle do
    cellar :any_skip_relocation
    sha256 "0dca1d48df364b776b7833511d45889e251e25db41e6ac3910b938cf4e6fc82c" => :catalina
    sha256 "793de068f56ef15d1b31c99e2b6f16aa823fd4e6f2cd552540cec7b6d29139ef" => :mojave
    sha256 "37a7240642f98a74c0ef540fbd4a518d5c9e1e7d5b5f7d35ecdf6aec3999276a" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}/mdbook init"
    system "#{bin}/mdbook", "build"
  end
end
