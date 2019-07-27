class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.12.5-src.tar.gz"
  sha256 "3638936cf6270eeeaabcee42e10768d78e4dc07cac9310307835c1f58b140808"
  head "https://github.com/kornelski/pngquant.git"

  bottle do
    cellar :any
    sha256 "a650ec508f72eca199998d521b1328d354d3645dcbb7519a3458fac676395d74" => :mojave
    sha256 "f544829d834c26215b9815841d298755683a03cbb2ab301298d0aa8bc01ace95" => :high_sierra
    sha256 "b9322d37953aa648c463fa0db8967c36897f26e8f15d801bebe30a165258fe96" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
    man1.install "pngquant.1"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
