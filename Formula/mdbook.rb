class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https://rust-lang-nursery.github.io/mdBook"
  url "https://github.com/rust-lang-nursery/mdBook/archive/v0.3.4.tar.gz"
  sha256 "5bb6671ce38957352b28a428c5bab26eff2c2fe2faf9c961ebdfb16d8f63cad6"

  bottle do
    cellar :any_skip_relocation
    sha256 "d7369e93785880f0ae48f52b3691a0783e0e078a755188fbf02fc2c69828abf5" => :catalina
    sha256 "63a4a4a8c4dac49cae5ce421f7a0c136503546e5d744a10e023b32ed3c7a10cb" => :mojave
    sha256 "6f8ffb98f3e1b01d8bad590505c7d8dc51d0788657e9d73830b17b710d7c8226" => :high_sierra
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
