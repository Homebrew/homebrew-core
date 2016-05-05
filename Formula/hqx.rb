class Hqx < Formula
  desc "Magnification filter designed for pixel art"
  homepage "https://code.google.com/p/hqx/"
  url "https://hqx.googlecode.com/files/hqx-1.1.tar.gz"
  sha256 "cc18f571fb4bc325317892e39ecd5711c4901831926bc93296de9ebb7b2f317b"
  revision 1

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
    assert_equal <<-EOS.undent, output
    \tArray
    \t(
    \t    [0] => 4
    \t    [1] => 4
    \t    [2] => 2
    \t    [3] => width="4" height="4"
    \t    [bits] => 8
    \t    [channels] => 3
    \t    [mime] => image/jpeg
    \t)
    EOS
  end
end
