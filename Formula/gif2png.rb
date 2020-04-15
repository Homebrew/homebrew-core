class Gif2png < Formula
  desc "Convert GIFs to PNGs"
  homepage "http://www.catb.org/~esr/gif2png/"
  url "http://www.catb.org/~esr/gif2png/gif2png-3.0.0.tar.gz"
  sha256 "98e185fa62d8d5b355a8b3980db0025b2fbdea991bd9f78547a1e0bc08b81d3a"

  bottle do
    cellar :any
    sha256 "cfbf0572aec85f33c51bc58064e20a44de374a319bb369e46c0aab8581756253" => :catalina
    sha256 "95c85cb74a70b1f217c3db5f4f6f6bab2b9871755435a25301bc4215015f1341" => :mojave
    sha256 "fd15459a5000f08952b7609ef743d80c84749710e30b7bfbe02d68e7ccc27ed7" => :high_sierra
    sha256 "25aa7ef95b5ca8e7a79bf884fa8e9c8eafb21f2887caabc3ffb40de5fda2ab26" => :sierra
  end

  depends_on "go" => :build

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    pipe_output "#{bin}/gif2png -O", File.read(test_fixtures("test.gif"))
  end
end
