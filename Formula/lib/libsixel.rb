class Libsixel < Formula
  desc "SIXEL encoder/decoder implementation"
  homepage "https://github.com/saitoha/libsixel"
  url "https://github.com/saitoha/libsixel/releases/download/v1.8.7-r2/sixel-1.8.7-r2.tar.gz"
  version "1.8.7-r2"
  sha256 "9088475e5a1332f84b92ad46fd3c199ac56500c67f8a4054efccbc0db644bdba"
  license "MIT"
  version_scheme 1
  head "https://github.com/saitoha/libsixel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "48d25cd9b90ad067a4a8dbc77811e21827c40185b86e6f978c631878e4e9c168"
    sha256 cellar: :any, arm64_sequoia: "7916ae0f4e67563b37584a7936d42fda2ce852a9c3e85ca979682ea5c525ffbf"
    sha256 cellar: :any, arm64_sonoma:  "44f1dfd4f375c01da233d76d3e6183fd1b611c6efa7be0afdde40f89956a0814"
    sha256 cellar: :any, sonoma:        "bc41609ca46bb7c7e3f0fa18c1710a6040cdd949b47bec2f23ba7a20fa9df9dd"
    sha256 cellar: :any, arm64_linux:   "c085fad95eb13f71971bd8e16bb1a041328b7f3f88f46a1001c8e488bf33f584"
    sha256 cellar: :any, x86_64_linux:  "2d9f918ca63ce72f515d7067e0d3c364b9dbcf4ada3f20afff71b62bf13e2303"
  end

  depends_on "pkgconf" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    system "./configure", "--disable-python",
                          "--without-libcurl",
                          "--with-jpeg",
                          "--with-png",
                          *std_configure_args
    system "make", "install"
  end

  test do
    fixture = test_fixtures("test.png")
    system bin/"img2sixel", fixture
  end
end
