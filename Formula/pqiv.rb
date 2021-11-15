class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.12.tar.gz"
  sha256 "1538128c88a70bbad2b83fbde327d83e4df9512a2fb560eaf5eaf1d8df99dbe5"
  license "GPL-3.0"
  revision 3
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "95115be75710f27f7d52cf7a9b10990e5a075ec26e9c3d13cb2a45410a7e9b95"
    sha256 cellar: :any, arm64_big_sur:  "0c8a40ee1f88749e55e3aa975ea32bfe8e616cc6158fb022e38a9b69e8cff13d"
    sha256 cellar: :any, monterey:       "fc2d2b8a7839d77b2afa73a529868a87fca5d7436a2105b91b6bd9734e2c2e73"
    sha256 cellar: :any, big_sur:        "017d77592bb99e60753d51ec9a0ce8c90f77c39fd509f7f3c13c67014f5284ae"
    sha256 cellar: :any, catalina:       "6433cfa629deffab7b4b107f04882c8be8bffcf544cd9559d08570d4da4d907c"
    sha256 cellar: :any, mojave:         "5faf09fb2c5ce8f2d468b95a1c0b041ce3dcc0d6480159d2d5b1815e402a0ea9"
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
