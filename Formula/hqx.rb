class Hqx < Formula
  desc "Magnification filter designed for pixel art"
  homepage "https://code.google.com/archive/p/hqx/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/hqx/hqx-1.1.tar.gz"
  sha256 "cc18f571fb4bc325317892e39ecd5711c4901831926bc93296de9ebb7b2f317b"
  revision 1

  bottle do
    cellar :any
    sha256 "1c7bb9de8f99fd227a2bcb82cad930e4643fe166a34bc49192ba0a563511ccd2" => :sierra
    sha256 "cea2aaffc8d25b52b4665c5af495489a5971ed125ce5595a83f94396ef8696dd" => :el_capitan
    sha256 "6ea1e409d4a9482c249dd9c17bfef20b7f34924ad96027dff47e8317615102be" => :yosemite
    sha256 "f0b02dadd6f2a3effec4865f4b042621e375e65ba016fec7658ecf8cfd11758a" => :mavericks
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
