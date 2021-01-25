class Jbig2dec < Formula
  desc "JBIG2 decoder and library (for monochrome documents)"
  homepage "https://jbig2dec.com/"
  url "https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs9531/jbig2dec-0.19.tar.gz"
  sha256 "279476695b38f04939aa59d041be56f6bade3422003a406a85e9792c27118a37"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/jbig2dec[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    cellar :any
    sha256 "44aa9639d58ac2e176c37538c3fe652e077bcbf82264b756b4ba9db041e9273c" => :big_sur
    sha256 "696d6862655e2919c4a6b1455923c2c26b3b9da7968aa2a6f6c0b544d10556f0" => :arm64_big_sur
    sha256 "7e70d2b2472b4116d1f98b7518f124067dbfa8e4d3d73b552af38440e7770bdd" => :catalina
    sha256 "d02d163a886d1f3a9e1af50418ed2f19f66981b44a58f3228b3580f585929ee4" => :mojave
    sha256 "8ec515805d2fab8f4db3b27afba0363428f341bb16fbda7d2708ef44fffc5285" => :high_sierra
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
