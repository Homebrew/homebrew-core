class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang.github.io/mdBook/"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.5.tar.gz"
  sha256 "73258ba3713004e06675ef2a1fbd3e7b48eb144db37c5ac1e2b96086b51a6e87"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f164851ce201f257d69d4d55e50fa7707cea1ab268a5b239266a4662845beef" => :catalina
    sha256 "1a2b15f790541dc456294475b42927a152ea614857dfb49ca5f1a00aec1e9509" => :mojave
    sha256 "b2305bde8f2f620393c813fc208e9364e0681eff43d6535e7202841fc832ec9c" => :high_sierra
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
