class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.27.0.tar.gz"
  sha256 "9dc5ce43c63d9d9ff510c6bcd6ae06f3f2f907347e7cbb2bb6513bfb0f151621"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf23db053d25081095366198f72f8b00ce272fd682d29e38f8af61dd3e5a61d5" => :big_sur
    sha256 "0c982e714b93db8139ca8712e994bcdba19c1341132304b17d282ce1a6caa13b" => :arm64_big_sur
    sha256 "02454d5571292dcc4520687ae721518de35deadccf7fe3b4de8eade2d19b27b1" => :catalina
    sha256 "6be47ea404f214c73485e722555c5f59c0a857cc553cc8a455763ac4d73f974a" => :mojave
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
