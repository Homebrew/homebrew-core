class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.6.tar.gz"
  sha256 "c44dcfac0a113c3bec13d0fc60faf57a0f9a31f88473ccad33ecdf210b4c0c52"
  license "GPL-2.0"
  head "https://github.com/tjko/jpegoptim.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "35c8849ace2b6b5e3ecab77e67ca84ff8e929a6ffb8782562b8c8d2cee70ce6b"
    sha256 cellar: :any,                 arm64_big_sur:  "38149f489f36745c9be64ccaff694c53a07c6a8d4c98335703e7c1ba6206c5e0"
    sha256 cellar: :any,                 monterey:       "1cf486d47809250bc5c67819ee9f82e5eba1fb4b6b8910229316f366d034ef23"
    sha256 cellar: :any,                 big_sur:        "ca4714cf1b1ecbc166a78b8143648fa639b70495f54dc75bcd1a71b9a2c4e604"
    sha256 cellar: :any,                 catalina:       "f6acdfbe5b3ff49f922bfccb936c39609bb1a0f9dbebd1289d1679bf7fe5b2a4"
    sha256 cellar: :any,                 mojave:         "c60d59cfe20db5ad448c4da58d7c43ca072f15a31502b989a51b9020da445880"
    sha256 cellar: :any,                 high_sierra:    "9588bffa63f2041939e480ff8dbce25a004ef2414fc7ea9d5b5177a38bfb8eaf"
    sha256 cellar: :any,                 sierra:         "89b7f8465e95066c6bf19515affed14037841ea5d0a86b8c3d6cf026f507e938"
    sha256 cellar: :any,                 el_capitan:     "cc6c60a27cba7bb5f0e1b4a7c8ae3567db4eeaf1e1384488b818da7a1409f837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9519adbc40ad2a3bdc57c0aef19e8e7accf1eaa3f862de4433569dbc293a0bfa"
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
