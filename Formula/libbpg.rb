class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "https://bellard.org/bpg/"
  url "https://bellard.org/bpg/libbpg-0.9.7.tar.gz"
  sha256 "05035862ff4ffca0280261871486f44e74c4af4337c931e0858483551e6efe25"

  bottle do
    cellar :any
    sha256 "0f8a8ca6afd5f64ac673b76ae2e6e22ab423db72bf57c3f169c03b18f56f455d" => :sierra
    sha256 "1b8c8dbbcbf6e63efaf2c46eb9a3d8b7c443e41fddcbeaed7e42fa61f77dedcd" => :el_capitan
    sha256 "7409ef3a42d911b3422bb18f98390064c5902452e9d31cce163915a7018dfd03" => :yosemite
  end

  option "with-jctvc", "Enable built-in JCTVC encoder - Mono threaded, slower but produce smaller file"
  option "without-x265", "Disable built-in x265 encoder - Multi threaded, faster but produce bigger file"

  depends_on "cmake" => :build
  depends_on "yasm" => :build if build.with? "x265"
  depends_on "libpng"
  depends_on "jpeg"

  def install
    bin.mkpath

    args = []
    args << "USE_JCTVC=y" if build.with? "jctvc"
    args << "USE_X265=" if build.without? "x265"

    system "make", "install", "prefix=#{prefix}", "CONFIG_APPLE=y", *args

    pkgshare.install Dir["html/bpgdec*.js"]
  end

  test do
    system "#{bin}/bpgenc", test_fixtures("test.png")
  end
end
