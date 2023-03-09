class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/2.12.tar.gz"
  sha256 "1538128c88a70bbad2b83fbde327d83e4df9512a2fb560eaf5eaf1d8df99dbe5"
  license "GPL-3.0"
  revision 6
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e17fbd19adfba4fdc573713331f18cbe87550de5b704f752d763f3f7d7e22a13"
    sha256 cellar: :any,                 arm64_monterey: "26640d26826157233d2ec78a06a392e6f86822b59851728b1bd464c65d5e8e1e"
    sha256 cellar: :any,                 arm64_big_sur:  "2f867b48156591c1c23b6a661122a8f4d0295e14864e802fd2fa81090a5ace44"
    sha256 cellar: :any,                 ventura:        "af580ea8722cec9dd7b4e630c9eac3a333ab3c48d5fab28e6a1a80d019c86662"
    sha256 cellar: :any,                 monterey:       "f475889e1b206362317aa74be2aa4bf1bc1989607586cb2dbce61d91157181b8"
    sha256 cellar: :any,                 big_sur:        "95b612456e3a948f0ade7c910191e3a99921424168d6cd7b2598d7438b0aba58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f63bffe4108075c27d10db43816be4c8ebf61131b55764d053b3229ab1e0505e"
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
