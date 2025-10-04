class Lhasa < Formula
  desc "LHA implementation to decompress .lzh and .lzs archives"
  homepage "https://fragglet.github.io/lhasa/"
  url "https://github.com/fragglet/lhasa/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "1ae8d82d37fc12ec2c52c520b6528ec61268e243f33eca4446b440e182c66d91"
  license "ISC"
  head "https://github.com/fragglet/lhasa.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c54634d428cfdd0fe31a8d993387e1d4d166e1081b82ab919354805a948ed432"
    sha256 cellar: :any,                 arm64_sequoia: "d6af1ccf1e48330e1c9b9d7a63187e2a963196cc65b6995ff236ecaa9fd8470b"
    sha256 cellar: :any,                 arm64_sonoma:  "d6da687747be968b1f452bb2c4f7df58dae56ac8c12bd9a7e22c800cbcd75ad6"
    sha256 cellar: :any,                 arm64_ventura: "c4a2d8a1b69b741ccc11541fe34c22eaf1ed22497d139f8f82ccc1488922cf38"
    sha256 cellar: :any,                 sonoma:        "8f514fe7d1d4d3621ceec8d41d130e0a362ceefd0be091e4cce36c01658d426e"
    sha256 cellar: :any,                 ventura:       "b3cb1bf8712c3b58ad3bb0fbaea6f480969b16c1fcb803db5291f29bf9ea44e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ad64de0374f0f74a9517c25f1641881a1e9fd24c538f500ae54445794831c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdb0cf0122a0acc12b80c409bc0d5e6e5a023909948068eeb2f3753f2ef9008c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    data = [
      %w[
        31002d6c68302d0400000004000000f59413532002836255050000865a060001666f6f0
        50050a4810700511400f5010000666f6f0a00
      ].join,
    ].pack("H*")

    pipe_output("#{bin}/lha x -", data)
    assert_equal "foo\n", (testpath/"foo").read
  end
end
