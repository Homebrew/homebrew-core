class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://jbig2dec.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs924/jbig2dec-0.15.tar.gz"
  sha256 "6bfa1af72de37c7929315933a1ba696540d860936ad98f9de02fc725d7e53854"

  bottle do
    cellar :any
    sha256 "85fc216faf078a49753c6cd65fd1bd2ce84d137f79e40af83de29d03e7794bd1" => :mojave
    sha256 "197656bee979449ea283d855f0332afa414a31f7114123f477f3f9f2cc192763" => :high_sierra
    sha256 "a98bac77f5b916d67c1c7742ee3462af053c2ff0726dacaf5b0bcb2e9aef7e74" => :sierra
    sha256 "beb6ea36ce8edffa4ff8569231413fab5f3de7338379b35b49d208e16243577d" => :el_capitan
  end

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
