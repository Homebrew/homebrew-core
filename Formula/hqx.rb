class Hqx < Formula
  desc "Magnification filter designed for pixel art"
  homepage "https://github.com/grom358/hqx"
  url "https://github.com/grom358/hqx.git",
      :tag      => "v1.2",
      :revision => "124c9399fa136fb0f743417ca27dfa2ca2860c2d"

  bottle do
    cellar :any
    sha256 "1a1f91371ce5bc0455725379f796243029016a1e866a71ff395d8f8a4e301481" => :mojave
    sha256 "5a548a5e9b16d78b7f913c4b6fece78202b13e416962a9a5a965c3e2d27461a8" => :high_sierra
    sha256 "7e58bc40ff9214f1b074595ac85c842ebafe676c6f3db42e3e0712c77c3377f4" => :sierra
    sha256 "6bf8b3b1b203ae43cc833480c8b395776d1369a38bb78fe2b47034ff8a8a0645" => :el_capitan
    sha256 "82f3574ae2e08ed7312d22b751b94be4783eccb2166fc1e45cc25ae90a7e5046" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
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
