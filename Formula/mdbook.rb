class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang-nursery.github.io/mdBook"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.2.3.tar.gz"
  sha256 "2e157d4f0437143caf65d9253f9084d8cc0fff7a9e42cff3641e8413e15688fa"

  bottle do
    cellar :any_skip_relocation
    sha256 "497c197838e767c8572e3310b36561a96cf15b6296b20156318d9e9cd2daa236" => :mojave
    sha256 "e8392185abbea0d12ecceb7cc0e6bbf074eb762baea8001fcfc963aa4393bf0c" => :high_sierra
    sha256 "0fb3e1ef2fe8e8f2c6d9e06e7396360cdf21b2a9307fd81d9a0ba3c7b822f634" => :sierra
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
