class Jbig2enc < Formula
  desc "JBIG2 encoder (for monochrome documents)"
  homepage "https://github.com/agl/jbig2enc"
  url "https://github.com/agl/jbig2enc/archive/refs/tags/0.29.tar.gz"
  sha256 "bfcf0d0448ee36046af6c776c7271cd5a644855723f0a832d1c0db4de3c21280"
  license "Apache-2.0"
  revision 3
  head "https://github.com/agl/jbig2enc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e56a40c42b91521dc85adbd0e64f139996cf651ccf20566791eb025562b5c989"
    sha256 cellar: :any,                 arm64_sonoma:   "b7e975bf348576e5e3aa681fc09c15b91f4cf7542b071027fb277e35d2f09e84"
    sha256 cellar: :any,                 arm64_ventura:  "5894ec7327cf835d5c03aa7dfe077ec1976e07587fe3f7f8a8d188b07d486dda"
    sha256 cellar: :any,                 arm64_monterey: "a616b755cbdaf4d7133f6a7dde4a1a8cf59295bf627b00a3a6f022e2c0b2010f"
    sha256 cellar: :any,                 arm64_big_sur:  "c4fd2fd1394266163c8e07b4378c09ddd57c408c3fdf8098b7c0931856c3e742"
    sha256 cellar: :any,                 sonoma:         "371b2cf59f44ff4d8a964095c5a1ba7f9883847576d2ee18d53ae0621e3e1ee4"
    sha256 cellar: :any,                 ventura:        "1e3b10797b108104ededfbdada4f6c03d288dbc3f4c2b75173d29796e53edac7"
    sha256 cellar: :any,                 monterey:       "fbf2dcb1e29ac4aff73463dd153d38357b073b9ab184001d6a9a4baabd44023d"
    sha256 cellar: :any,                 big_sur:        "9cc450a97ea92e1b86cc68b4b521971de0f3816939b495fa9ca8ac5b8d66c7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de11ca25b4e186c650ecf95a3711f6cb8ae605b52054553c3b1814f0aabca269"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "leptonica"

  on_macos do
    depends_on "giflib"
    depends_on "jpeg-turbo"
    depends_on "libpng"
    depends_on "libtiff"
    depends_on "webp"
  end

  # The following two patches fix build with leptonica >= 1.83.
  # Remove them when they are included in a release.
  patch do
    url "https://github.com/agl/jbig2enc/commit/a614bdb580d65653dbfe5c9925940797a065deac.patch?full_index=1"
    sha256 "93106a056562e1268403a30bdab46f8f3fa332b68fb169a494541ea944d6ba2f"
  end
  patch do
    url "https://github.com/agl/jbig2enc/commit/d211d8c9c65fbc103594580484a3b7fa0249e160.patch?full_index=1"
    sha256 "a1e7b44b9ea28d32d034718fb10022961dcec32b74beda56575f84416081bd43"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "JBIG2 compression complete",
                 shell_output("#{bin}/jbig2 -s -S -p -v -O out.png #{test_fixtures("test.jpg")} 2>&1")
    assert_predicate testpath/"out.png", :exist?
  end
end
