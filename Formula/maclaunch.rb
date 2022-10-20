class Maclaunch < Formula
  desc "Manage your macOS startup items"
  homepage "https://github.com/hazcod/maclaunch"
  url "https://github.com/hazcod/maclaunch/archive/2.3.2.tar.gz"
  sha256 "c751bfaf57ec796d8d6e53c3be41c847598fb40c1df7dd3e720b33253a69f7fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "99d01d6f2421a1178744e66ca594636adb8d4e7ae6efcd9f3f688be215667977"
  end
  depends_on :macos

  def install
    bin.install "maclaunch.sh" => "maclaunch"
  end

  test do
    system bin/"maclaunch", "list"
  end
end
