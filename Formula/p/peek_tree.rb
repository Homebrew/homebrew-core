class PeekTree < Formula
  desc "Enhanced directory tree viewer with file previews"
  homepage "https://github.com/aymanhki/peek_tree"
  url "https://github.com/Aymanhki/peek_tree/releases/download/v1.2.3/peek_tree-macos.tar.gz"
  sha256 "e882984b8b5dc753f746630fffa2a409eb47dfb6e9f53b68ff8e57170a75ac40"
  license "MIT"

  def install
    bin.install "peek_tree"
  end

  test do
    system bin/"peek_tree", "-h"
  end
end
