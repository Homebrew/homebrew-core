class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.12.5-src.tar.gz"
  sha256 "3638936cf6270eeeaabcee42e10768d78e4dc07cac9310307835c1f58b140808"
  head "https://github.com/kornelski/pngquant.git"

  bottle do
    cellar :any
    sha256 "1028a880ea5c1a174342bebe770a4c0b69d100dcf24feaf8bd09c87883591267" => :catalina
    sha256 "db0913702e59ad3c915048b4e61db30b78f09379832403f2803f3c260ad3302f" => :mojave
    sha256 "b250a11b048c83e1f03af42bfc2da26239765bb236647eef6fb588c2832b4d49" => :high_sierra
    sha256 "53ccff678414e2f8f8ae3f290e67e99679e94be4be27cffa8e1aab5344d8bd82" => :sierra
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
