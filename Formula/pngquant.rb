class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.15.1-src.tar.gz"
  sha256 "718aabbc346b82ed93564d8e757b346988d86de268ee03d2904207cd5d64c829"
  license :cannot_represent
  head "https://github.com/kornelski/pngquant.git"

  livecheck do
    url "https://pngquant.org/releases.html"
    regex(%r{href=.*?/pngquant[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "15ad178832ed8498202c09ab7c1004172759e2ea12cb0e9da6b70f7c428c8751"
    sha256 cellar: :any, big_sur:       "f7078b57e01270277726dcd727c533a92b4dd43a0f7f9ad3bdf757d33488cd55"
    sha256 cellar: :any, catalina:      "06bb0ee458ca517afdd363cef6eb50886958fc36400b1a921a4644c3bbf41c80"
    sha256 cellar: :any, mojave:        "7132f0003c3b1caf6ba2a920844a83c6a59cb9c64e458e4eda548a7900917386"
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
