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
    sha256 cellar: :any,                 arm64_ventura:  "40167fcb5c1af7d0528cc234693e61305b9f12f279a78598345874e1e5ffc65e"
    sha256 cellar: :any,                 arm64_monterey: "0863a99895ee5131ed359b3abc486557f80ee20ef4607d6066efb3af89b12384"
    sha256 cellar: :any,                 arm64_big_sur:  "381b9ea76185f39a8bf68433b27341e8173479f822b2f5b72db3ba996c3e4325"
    sha256 cellar: :any,                 ventura:        "24c1706e05d6f8fbaa96e4022279acd41577863eff7b0c307292f6848895a180"
    sha256 cellar: :any,                 monterey:       "e1c3fd851c4342ac53ad8fb592e1231ff2f209ab745064598b2d5480fee2c35e"
    sha256 cellar: :any,                 big_sur:        "88c043c714e64a92e10bfd7ba6e351793e363f1a792846bcf91c4bc8dd3a3949"
    sha256 cellar: :any,                 catalina:       "5a57521e5b9c5024c56a3e1c09d485dc3af5a6cbfdecdf0804ccec6cfc61c117"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19d0be8e84bc845c63c847adfedd6c8ad4a8b9176cf2c3b602c7a7f7966179fd"
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
