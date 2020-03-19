class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://jbig2dec.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs951/jbig2dec-0.18.tar.gz"
  sha256 "9e19775237350e299c422b7b91b0c045e90ffa4ba66abf28c8fb5eb005772f5e"

  bottle do
    cellar :any
    sha256 "fcf5e2f4d25c553c6cdada4364e37d08850eea59cda5e2177503d8eb7ecf0aef" => :catalina
    sha256 "e437d5f1391cb3b85a1f11246fa87ab9b3396ce10f3b25801d2a614b79d09cfc" => :mojave
    sha256 "7bbc9569c46647373ca333801e335d8839078eb61c94e36a3d53e1e2c323c58c" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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

    system "./autogen.sh", *args
    system "make", "install"
  end

  test do
    resource("test").stage testpath
    output = shell_output("#{bin}/jbig2dec -t pbm --hash testJBIG2.jb2")
    assert_match "aa35470724c946c7e953ddd49ff5aab9f8289aaf", output
    assert_predicate testpath/"testJBIG2.pbm", :exist?
  end
end
