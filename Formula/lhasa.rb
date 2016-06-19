class Lhasa < Formula
  desc "LHA implementation to decompress .lzh and .lzs archives"
  homepage "https://fragglet.github.io/lhasa/"
  url "https://github.com/fragglet/lhasa/archive/v0.3.1.tar.gz"
  sha256 "ad76d763c7e91f47fde455a1baef4bfb0d1debba424039eabe0140fa8f115c5e"
  head "https://github.com/fragglet/lhasa.git"

  bottle do
    cellar :any
    sha256 "9bf2cc5224e9cd76854a180c426b0b455cf4c3b148439b496c2e3de2bc0bcc90" => :el_capitan
    sha256 "e165d272782133234ee3064fcb3dcac1923c3fe5d79891cb181619b6d8e79dde" => :yosemite
    sha256 "c7c28b850933f06b27a7af32a73a840437663aa334010eb097ecb7f3ff6dd4c1" => :mavericks
    sha256 "af8aac8f99b3cf42dde5e69d0f18e1e72370cde24b3b00fb1577fd5a99e54489" => :mountain_lion
  end

  conflicts_with "lha", :because => "both install a `lha` binary"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    data = [
      %w[
        31002d6c68302d0400000004000000f59413532002836255050000865a060001666f6f0
        50050a4810700511400f5010000666f6f0a00
      ].join
    ].pack("H*")

    pipe_output("#{bin}/lha x -", data)
    assert_equal "foo\n", (testpath/"foo").read
  end
end
