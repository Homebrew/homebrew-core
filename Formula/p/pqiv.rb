class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/refs/tags/2.13.1.tar.gz"
  sha256 "1db8567f75884dfc5dd41208f309b11e4e4ca48ecad537915885b64aa03857a4"
  license "GPL-3.0-or-later"
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "64ed8d69732b2089fda1b093211dda4331cda4af45bb599be4f736393c7d896e"
    sha256 cellar: :any,                 arm64_ventura:  "dad1306c3bcdbabab4c7b1aa823f79c0d2b6e66c9753e8576d4184ae68899879"
    sha256 cellar: :any,                 arm64_monterey: "4b7d46d5aea5d3c0d5f68c9d3a60baf5d3e54ba1c5d4e77470cd5dd0ccedb228"
    sha256 cellar: :any,                 sonoma:         "09d8b03ca42ce173505ca01652a6228a01b183c67b7b979d828757cb17f15d90"
    sha256 cellar: :any,                 ventura:        "6a72503091cb5fea9a0c7f51e1f1ac9d6c6d1d7da0a5c1f4db7e4b3aca9865ea"
    sha256 cellar: :any,                 monterey:       "94b2b92f30c8fd6755fd83a3743d4aa890f660e35b8080c5fc3fd91832ac266d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b939a096a5dd8f49fe2da29db4b40b82d6b8a99f63c8f64342c1ad99d7089c6"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "webp"

  on_linux do
    depends_on "libtiff"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
