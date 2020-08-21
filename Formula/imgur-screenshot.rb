class ImgurScreenshot < Formula
  desc "Take screenshot selection, upload to imgur. + more cool things"
  homepage "https://github.com/jomo/imgur-screenshot"
  url "https://github.com/jomo/imgur-screenshot/archive/v2.0.0.tar.gz"
  sha256 "1581b3d71e9d6c022362c461aa78ea123b60b519996ed068e25a4ccf5a3409f5"
  license "MIT"
  head "https://github.com/jomo/imgur-screenshot.git"

  bottle :unneeded

  def install
    bin.install "imgur-screenshot"
    bin.install_symlink "imgur-screenshot" => "imgur-screenshot.sh"
  end

  test do
    # Check deps
    system bin/"imgur-screenshot", "--check"
    system bin/"imgur-screenshot.sh", "--check"
  end
end
