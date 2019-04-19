class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://jbig2dec.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs927/jbig2dec-0.16.tar.gz"
  sha256 "a4f6bf15d217e7816aa61b92971597c801e81f0a63f9fe1daee60fb88e0f0602"

  bottle do
    cellar :any
    sha256 "9b13b7bdd2a907bad49d5e71d8b97604afdc8581fa37a73304b0d147e11cbb3e" => :mojave
    sha256 "880df1d4364a329a3a4f78d32360f3bba01fe422877ea10e0170db06d57f8637" => :high_sierra
    sha256 "53ef474b4a04148edd1c7b2bdb5529c674a72316ecda7d46410c8e8ae0368542" => :sierra
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
