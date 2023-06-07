class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.12.tar.gz"
  sha256 "1538128c88a70bbad2b83fbde327d83e4df9512a2fb560eaf5eaf1d8df99dbe5"
  license "GPL-3.0"
  revision 6
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bd472d3115ae616771f87e49202dc724acab4fadc1e4160ee482b7732e469a33"
    sha256 cellar: :any,                 arm64_monterey: "33b25feb413e20e9251f8894a9ed0bfbcf976e9fef69924346abaa6ef5dd9a32"
    sha256 cellar: :any,                 arm64_big_sur:  "592107c51d103ec69e312593833579975bccbee9b36390fe37f4234340755731"
    sha256 cellar: :any,                 ventura:        "02dcebc9faa615cb079ca3b471da4e892c780b4e0d2e685c6bae3b1c02f543a2"
    sha256 cellar: :any,                 monterey:       "7a75809c729c1ec7a3e71a94f26de9976f71142b2998edbe5187797646cb1e5b"
    sha256 cellar: :any,                 big_sur:        "577abb3ab63808e9080afd934bc99bdb305cefd0ee10494b18a2d95e3c48d960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1779c1c2f24884cb7be8cdba82378bee96cf9941a4d51aa7e0268515f489834"
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
