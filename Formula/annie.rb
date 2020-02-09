class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.8.tar.gz"
  sha256 "49bad7855cfacde8c55cf7d2c5bb8b5e5bf6d8853a414e5c5ca6447d9f7be3ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca7ad8a511064b1a271826c20796a87359e9fcbaa6d35e5a319babdf4d930c93" => :catalina
    sha256 "694bbb12e3b4b1a61a363f3c9828a813ca13f68110547f4d7dcad540930713ae" => :mojave
    sha256 "fb6cd92f169451489dfc26c94a93aedc5c7e654df1550a3356ea02b046d69bdb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"annie"
    prefix.install_metafiles
  end

  test do
    system bin/"annie", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
