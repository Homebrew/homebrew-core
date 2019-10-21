class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang-nursery.github.io/mdBook"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.2.tar.gz"
  sha256 "93caeeda86a4abf3b2da805ba1fc609a9f2803f9a37875ff30a87f1ead7c7c22"

  bottle do
    cellar :any_skip_relocation
    sha256 "81d2b417bee78bd5f22c8847cd3e9d2f8369758567e9ad8c405753c2cf052316" => :catalina
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
