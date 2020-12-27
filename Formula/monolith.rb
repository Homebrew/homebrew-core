class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https://github.com/Y2Z/monolith"
  url "https://github.com/Y2Z/monolith/archive/v2.4.0.tar.gz"
  sha256 "aba401677d9586b973a4719a945ffad70a6bef8adc737437a73aa7ed8709eae4"
  license "Unlicense"

  bottle do
    cellar :any_skip_relocation
    sha256 "2f9188c982346fa01eae772a38a94d85c5f2caa5c8c9ead9c180d2062b80a31a" => :big_sur
    sha256 "990adc89aa28d7ac21f5655a43e67a00ffed8b2ee674a656fa72f4cb6b2c3cd4" => :arm64_big_sur
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
    system bin/"monolith", "https://lyrics.github.io/db/P/Portishead/Dummy/Roads/"
  end
end
