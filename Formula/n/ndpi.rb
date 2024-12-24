class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/refs/tags/4.12.tar.gz"
  sha256 "28b0029877bbc970a8acc924664541c71e76e7a45e3761d5d0ddf3e695b6878c"
  license "LGPL-3.0-or-later"
  head "https://github.com/ntop/nDPI.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf0637b3cf5f016b1aa4a58bd144c3ced2c88656bb5be973b74e3366a74be4ba"
    sha256 cellar: :any,                 arm64_sonoma:  "516d894aea4a68b618a156a03ead2500bfd82d7aefc6695cbf69af46e217eb1e"
    sha256 cellar: :any,                 arm64_ventura: "d297b296f2dfda154d6f25de7c442de06dd1184e7b5091876b5217a5cd5d033b"
    sha256 cellar: :any,                 sonoma:        "93315328adbb6bd402a3beadae655f4169f4cbbf3f3ddf4a88ba6d2f1d6a9de2"
    sha256 cellar: :any,                 ventura:       "4f7060394acb0ce6edc09f5e58ec250a93c9476555761959af6a5b8ef7af4e9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77dc577fa30a25ad44a5016594faf8b22cce222b528f7862f70e59146aeda3c8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "json-c"

  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
