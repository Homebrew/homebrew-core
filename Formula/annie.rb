class Annie < Formula
  desc "Fast, simple and clean video downloader"
  homepage "https://github.com/iawia002/annie"
  url "https://github.com/iawia002/annie/archive/0.9.6.tar.gz"
  sha256 "e5e505ff7c7363fed6dbeed7ccefb3af726312ae19fd290b3179f5d41cb63d22"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "26f0634743808cb254fccef6bb2bf1aaddb47d6afefc5833b9fa73c0ab8ba118" => :catalina
    sha256 "1cf5f2033c1bcdc77780f0c7ae5e84522470928bbbd1ccd927d2916a82ba515d" => :mojave
    sha256 "fc64e3d49a0e499f5e5323a42a15d12820556f8ada2560fa4047ed32a578c962" => :high_sierra
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
