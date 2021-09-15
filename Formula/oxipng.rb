class Oxipng < Formula
  desc "Multithreaded PNG optimizer written in Rust"
  homepage "https://github.com/shssoichiro/oxipng"
  url "https://github.com/shssoichiro/oxipng/archive/v5.0.0.tar.gz"
  sha256 "2a3197c9a0afdd91967f9981da7ce684b40eced4191c26c167b3c214a7cfd9ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6e8b30db2b822ae1302ddb7e5491f6b41197395604aea8d3a390e6ae2f5b5491"
    sha256 cellar: :any_skip_relocation, big_sur:       "28bed379e7c13681208027dfb2e3f5af489c7fbb8818e9285f8326c669705ac9"
    sha256 cellar: :any_skip_relocation, catalina:      "a1ac61f28ff069dda9d2554f2e682e80ddbf927668de174c8faa1effcf09e0b4"
    sha256 cellar: :any_skip_relocation, mojave:        "f2a4d6a15d5571ddf64a010fd0531326c8f97ea01563ae47035e15cd7dbd3ca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a81dd2adb511b1174c68c324f46c4ea26ed9d4f0d874fd9c600ddb55f5dfbcae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"oxipng", "--pretend", test_fixtures("test.png")
  end
end
