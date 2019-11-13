class Bingrep < Formula
  desc "Greps through binaries from various OSs and architectures"
  homepage "https://github.com/m4b/bingrep"
  url "https://github.com/m4b/bingrep/archive/v0.8.1.tar.gz"
  sha256 "a3d93a3e30f306e5273b95e212007cff5918423d2386233a8625b7f3cf18a0e0"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"bingrep", bin/"bingrep"
  end
end
