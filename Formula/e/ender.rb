class Ender < Formula
  desc "Cross-platform Minecraft NeoForge manager"
  homepage "https://github.com/scirats/ender"
  url "https://github.com/scirats/ender/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "6a0def9580113f2f407241af7c00811e43d247d4b6e72f87339ab697171d07a5"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--path", ".", "--root", prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ender --version")
  end
end
