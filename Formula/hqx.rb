class Hqx < Formula
  desc "Magnification filter designed for pixel art"
  homepage "https://code.google.com/archive/p/hqx/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hqx/hqx-1.1.tar.gz"
  sha256 "cc18f571fb4bc325317892e39ecd5711c4901831926bc93296de9ebb7b2f317b"
  revision 2

  bottle do
    cellar :any
    sha256 "1a1f91371ce5bc0455725379f796243029016a1e866a71ff395d8f8a4e301481" => :mojave
    sha256 "5a548a5e9b16d78b7f913c4b6fece78202b13e416962a9a5a965c3e2d27461a8" => :high_sierra
    sha256 "7e58bc40ff9214f1b074595ac85c842ebafe676c6f3db42e3e0712c77c3377f4" => :sierra
    sha256 "6bf8b3b1b203ae43cc833480c8b395776d1369a38bb78fe2b47034ff8a8a0645" => :el_capitan
    sha256 "82f3574ae2e08ed7312d22b751b94be4783eccb2166fc1e45cc25ae90a7e5046" => :yosemite
  end

  depends_on "devil"

  def install
    ENV.deparallelize
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
