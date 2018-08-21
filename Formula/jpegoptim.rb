class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.6.tar.gz"
  sha256 "c44dcfac0a113c3bec13d0fc60faf57a0f9a31f88473ccad33ecdf210b4c0c52"
  head "https://github.com/tjko/jpegoptim.git"

  bottle do
    cellar :any
    sha256 "c60d59cfe20db5ad448c4da58d7c43ca072f15a31502b989a51b9020da445880" => :mojave
    sha256 "9588bffa63f2041939e480ff8dbce25a004ef2414fc7ea9d5b5177a38bfb8eaf" => :high_sierra
    sha256 "89b7f8465e95066c6bf19515affed14037841ea5d0a86b8c3d6cf026f507e938" => :sierra
    sha256 "cc6c60a27cba7bb5f0e1b4a7c8ae3567db4eeaf1e1384488b818da7a1409f837" => :el_capitan
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
