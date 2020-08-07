class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.3.1.tar.gz"
  sha256 "b99fdc2cff81488f7ddb52bfc505697f76ac494c6d261704b98d3e1432d66645"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3dc3a9d7415b6599f7b2d8405b54f5af8aaff550d0536cef47817cd4cc134fb" => :catalina
    sha256 "5244b390e2a4465b4d9e882353fbf0b7ecb01a03011f4268a8fa4b066bcda42b" => :mojave
    sha256 "1f6f354e4b427036593fa4c7a93f8b1d551455f8a423f0e9f73550a230978b35" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"monolith", "https://lyrics.github.io/db/p/portishead/dummy/roads"
  end
end
