class Alacritty < Formula
  desc "Cross-platform, GPU-accelerated terminal emulator"
  homepage "https://github.com/jwilm/alacritty"
  url "https://github.com/jwilm/alacritty/archive/v0.2.1.tar.gz"
  sha256 "d335f09ba914faf8d8b2ba91a67672aab3acd1a3bb1528ec3d9339381697f6a1"
  depends_on "rust" => :build

  def install
    system "make", "app"
    bin.install "target/release/osx/Alacritty.app/Contents/MacOS/alacritty"
  end

  test do
    system "#{bin}/alacritty", "-V"
  end
end
