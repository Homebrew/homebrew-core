class Neovide < Formula
  desc "No Nonsense Neovim Client in Rust"
  homepage "https://github.com/neovide/neovide"
  url "https://github.com/neovide/neovide/archive/tags/0.9.0.tar.gz"
  sha256 "a4c68cd2f3633f1478dc22ac5f27c636de236fdfe6641f558d65b846d1fbe1c8"
  license "MIT"

  depends_on "rust" => :build
  depends_on "neovim"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "libxcb"
  end

  def install
    system "cargo", "install", *std_cargo_args
    bin.install "target/release/neovide"
  end

  test do
    system bin/"neovide", "--remote-tcp=localhost:6666"
  end
end
