class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.13.1-src.tar.gz"
  sha256 "4b911a11aa0c35d364b608c917d13002126185c8c314ba4aa706b62fd6a95a7a"
  license :cannot_represent
  head "https://github.com/kornelski/pngquant.git"

  livecheck do
    url "https://pngquant.org/releases.html"
    regex(%r{href=.*?/pngquant[._-]v?(\d+(?:\.\d+)+)-src\.t}i)
  end

  bottle do
    cellar :any
    sha256 "581ba7e25c2df8ac52853df3771ac13c151a23d2f0d932fa9bf532e483c3aba0" => :big_sur
    sha256 "02b1cdd8853cd9b69cc5afead63c26af493ede6b6ee4199a040f3dd7a3302357" => :arm64_big_sur
    sha256 "a19326b4dd20ac58d8048cb5f540e3a278e454ca58c786ba4a2141926bb28cf3" => :catalina
    sha256 "a6a7ae1b165e9f571fcb5b9708f9b14f4a566a4b37b256429c98ec6949ac0b06" => :mojave
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
