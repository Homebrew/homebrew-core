class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://jbig2dec.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs950/jbig2dec-0.17.tar.gz"
  sha256 "f72bad7102638b31fa96be7492fb3d447a83d71c644cffd01f2a7ec52bd5fb72"

  bottle do
    cellar :any
    sha256 "d6e856504fb8490ff3b1a40db213bc4f25d1cc34fe68b28d4c2d51eb98e21045" => :catalina
    sha256 "6b541fd56271c00e6892c13a7481ab0c6faf4a22fe307ba6ce4ff7a6830870db" => :mojave
    sha256 "ed9651397b1be64c3e259e52a199367c27f261cf7c91d22ee6aae8d705049318" => :high_sierra
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
