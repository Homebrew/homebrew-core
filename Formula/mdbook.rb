class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang/mdBook/archive/v0.4.2.tar.gz"
  sha256 "9baebd8359442b1ff99a8ae4d8d197721525b746399e01f7fdcb67b4c34dd497"
  license "MPL-2.0"
  head "https://github.com/rust-lang/mdBook.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80e2274cd77ad98d5e3a4b131d3c8b2b190cb1a2711334989413f9c54c2afad8" => :catalina
    sha256 "1ccf1f4096e69ee5775c4e9874ae9189784d590d81faa1ace5160c9eda00a646" => :mojave
    sha256 "d521821171b2bd636edbdd75b3bb921b68435ca556e335955a32f412329d3264" => :high_sierra
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
