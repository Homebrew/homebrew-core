class Polyrhythmix < Formula
  desc "Polyrhythmically-inclinded MIDI Drum generator"
  homepage "https://github.com/dredozubov/polyrhythmix"
  url "https://github.com/dredozubov/polyrhythmix/archive/refs/tags/0.1.0.tar.gz"
  sha256 "d4122d34dde52681e217304a8f4c3b10363c964d57f4b2608fb2448b5c83a3c9"
  license "Unlicense"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/poly", "-K", "4xxxx"
  end
end
