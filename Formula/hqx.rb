class Hqx < Formula
  desc "Magnification filter designed for pixel art"
  homepage "https://github.com/grom358/hqx"
  url "https://github.com/grom358/hqx.git",
      tag:      "v1.2",
      revision: "124c9399fa136fb0f743417ca27dfa2ca2860c2d"
  license "LGPL-2.1"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "09abea6af7106f8bdcf0e58e7b17cd91e1c22074139596a2c4f23afdbf9c9a07"
    sha256 cellar: :any,                 arm64_big_sur:  "d782e36758fe3e2a3b354a3c9e021078230934c2bbc2bd4f7043cf7ad570f542"
    sha256 cellar: :any,                 monterey:       "3d8f69b255851ecfcefd4ddaf2011eb70a2a038868001194fcff7f87c777c891"
    sha256 cellar: :any,                 big_sur:        "8eccb719985ba896880e42efd7266c24ee920c3952441ac90f8fb327c875b1c0"
    sha256 cellar: :any,                 catalina:       "d59524a43357e8590e15fbb039891261b2d3c6c33bf073fece8bfa568c3b9710"
    sha256 cellar: :any,                 mojave:         "3714c62ed8c552ddf8242b87845c5d35d17341d44ffea5cc3feceaa2e4c7e960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d10418410cbd8fb6be975c40e233a41031491a307ef05a021f5be55e379063cc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "php" => :test
  depends_on "devil"

  def install
    ENV.deparallelize
    system "autoreconf", "-iv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"hqx", test_fixtures("test.jpg"), "out.jpg"
    output = pipe_output("php -r \"print_r(getimagesize(\'file://#{testpath}/out.jpg\'));\"")
    assert_equal <<~EOS, output
      Array
      (
          [0] => 4
          [1] => 4
          [2] => 2
          [3] => width="4" height="4"
          [bits] => 8
          [channels] => 3
          [mime] => image/jpeg
      )
    EOS
  end
end
