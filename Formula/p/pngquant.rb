class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.18.0-src.tar.gz"
  sha256 "e72194b52b36f040deaec49a1ddd5dcd8d4feecc3a5fe6c5e9589a9707b233d4"
  license :cannot_represent
  head "https://github.com/kornelski/pngquant.git", branch: "master"

  livecheck do
    url "https://pngquant.org/releases.html"
    regex(%r{href=.*?/pngquant[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "55fab88e60676f665814df9e581bdf08fc702c017710b5014b62b71918cc5c5a"
    sha256 cellar: :any,                 arm64_monterey: "2a9880d5f9082fefeaa293e839b4c4c13cf667727f25a051fdaed81d893fd343"
    sha256 cellar: :any,                 arm64_big_sur:  "0ac3705e4b0be4c8fddcf74651060c9f8c4a06cf606cf29487f4c7b1cb54e92c"
    sha256 cellar: :any,                 ventura:        "4d2a131a292a55106feb2513cada8dcbd1b8028ddc59d7bb95a189b2ce51fd6e"
    sha256 cellar: :any,                 monterey:       "fc3d3fd03d19f8ff9dcf2832262cd093bb3716f2362c17e5587930b5f3b974b5"
    sha256 cellar: :any,                 big_sur:        "04f276c7261989d2c5af611cc8ee54e4bd6fe50b7e1f4d5df870564ce7b7f612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d482fb76dc638ad8271269b95af411697e9d1f1ac21abc3f19ceace8af285ea8"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
