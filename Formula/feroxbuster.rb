class Feroxbuster < Formula
  desc "Fast, simple, recursive content discovery tool written in Rust"
  homepage "https://epi052.github.io/feroxbuster"
  url "https://github.com/epi052/feroxbuster/archive/v2.3.3.tar.gz"
  sha256 "5a244d1614fb9dc476e9be8bd1cdbb33e0b07a1fcb7285e911ae6c77a44c7327"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      To use feroxbuster, additional wordlists are required.
      A good source is: https://github.com/danielmiessler/SecLists
    EOS
  end

  test do
    system bin/"feroxbuster", "-h"
  end
end
