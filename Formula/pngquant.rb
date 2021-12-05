class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.17.0-src.tar.gz"
  sha256 "a27cf0e64db499ccb3ddae9b36036e881f78293e46ec27a9e7a86a3802fcda66"
  license :cannot_represent
  head "https://github.com/kornelski/pngquant.git", branch: "master"

  livecheck do
    url "https://pngquant.org/releases.html"
    regex(%r{href=.*?/pngquant[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "36491c30d4c13ca8b5bd11a3d8a801ca32dd5330e132a928395769f5bbedc097"
    sha256 cellar: :any,                 arm64_big_sur:  "40dcccce85d18cb3856d0bb0e03333c284c2b70f06ecefceb49b2462429cd6e2"
    sha256 cellar: :any,                 monterey:       "87a50256a7579608ff5451f545147df2cb3211b18642bebf916ae7a21d8f3423"
    sha256 cellar: :any,                 big_sur:        "a2b2c5cfdc1fff019e862f6dac8a94ead558c782e49de817bd9409c889afda31"
    sha256 cellar: :any,                 catalina:       "02e30d512da8181a987e93384bcb0cc834e99567ad2ceb93750e74fae0ff34c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "182cd1568a0c3afe0c3c2347e342f2af7c63d30e20b411a928c74548a5b25e03"
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
