class Maclaunch < Formula
  desc "Manage your macOS startup items"
  homepage "https://github.com/hazcod/maclaunch"
  url "https://github.com/hazcod/maclaunch/archive/2.3.1.tar.gz"
  sha256 "abba1f7cffd7f694b23745f6ccc137b17b6c9ea38fe2fbb55a8bd9646f6ae1a1"
  license "MIT"
  depends_on :macos

  def install
    bin.install "maclaunch.sh" => "maclaunch"
  end

  test do
    system bin/"maclaunch", "list"
  end
end
