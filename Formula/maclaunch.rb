class Maclaunch < Formula
  desc "Manage your macOS startup items"
  homepage "https://github.com/hazcod/maclaunch"
  url "https://github.com/hazcod/maclaunch/archive/2.4.tar.gz"
  sha256 "9ae98a3bf592f002d2235f240c4c3318551cb17cdf1680ad060000fd69e11bf9"
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
