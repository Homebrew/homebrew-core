class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.15.1-src.tar.gz"
  sha256 "718aabbc346b82ed93564d8e757b346988d86de268ee03d2904207cd5d64c829"
  license :cannot_represent
  head "https://github.com/kornelski/pngquant.git", branch: "master"

  livecheck do
    url "https://pngquant.org/releases.html"
    regex(%r{href=.*?/pngquant[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "08f465118abd80eaf2a87fa5fcdfc453edaf7e3e1ed49b85dd9e12f5813f50b9"
    sha256 cellar: :any,                 arm64_big_sur:  "ed5a067febf7c6cbf819c51f79c0623ba6cb64e155ad1e95d35cc3162aa67ee8"
    sha256 cellar: :any,                 monterey:       "abb5260619541a3f7a086e2c4e94c238e81d04a5f056a5609fdfeb5f1909e2f0"
    sha256 cellar: :any,                 big_sur:        "0bc025960043fb557d6d539dcf23b28b92f2bea1510633ab60f18be46291df69"
    sha256 cellar: :any,                 catalina:       "4ebceda76f537444ec729a1728b319f3023b2e14d22e7921c6159060c20e0bea"
    sha256 cellar: :any,                 mojave:         "ca06335788b3f0e24dd910b8efaf6222f4c742cbb5bf2bbdc6ec4e6bf802b69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79d1c82a5d9cbe75765ac1db9172fe6275307615abb73ff91070d355ecd8fce1"
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
