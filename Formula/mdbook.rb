class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang-nursery.github.io/mdBook"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.2.tar.gz"
  sha256 "93caeeda86a4abf3b2da805ba1fc609a9f2803f9a37875ff30a87f1ead7c7c22"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b0657ca3bcbadc7c9f2a99721a377fd74efaf345b3bd4424625c6b828a0ef39" => :catalina
    sha256 "b3131b765516f4b2deb4f8f8000c2b8baf8ff2f20d77920d555e96ff9f327e53" => :mojave
    sha256 "d356b1907af38f718ef639adf23a6de5a8716dd5450d55a456efcbb84fa4af56" => :high_sierra
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
