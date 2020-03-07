class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://jbig2dec.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs950/jbig2dec-0.17.tar.gz"
  sha256 "f72bad7102638b31fa96be7492fb3d447a83d71c644cffd01f2a7ec52bd5fb72"

  bottle do
    cellar :any
    sha256 "8656a96c7c445128f5cdeaa820a75df51d018fbc165a8e5991e9bcfa3268c9ba" => :catalina
    sha256 "4f3bb46fc8727b6aa1b6def6b9d6893078cf929d0ed37e432ea864810ad6ddf7" => :mojave
    sha256 "1b2684d8ba1e74ed1f5d8eaaee419859056aa5cbc85a6979fd16241d658c08d7" => :high_sierra
    sha256 "63c219877b391ee3198d8d60e7fbb4635d43af160b63ba1a2ef8309125c1ca50" => :sierra
  end

  depends_on "autoconf" => :build

  resource("test") do
    url "https://github.com/apache/tika/raw/master/tika-parsers/src/test/resources/test-documents/testJBIG2.jb2"
    sha256 "40764aed6c185f1f82123f9e09de8e4d61120e35d2b5c6ede082123749c22d91"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
      --without-libpng
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    resource("test").stage testpath
    output = shell_output("#{bin}/jbig2dec -t pbm --hash testJBIG2.jb2")
    assert_match "aa35470724c946c7e953ddd49ff5aab9f8289aaf", output
    assert_predicate testpath/"testJBIG2.pbm", :exist?
  end
end
