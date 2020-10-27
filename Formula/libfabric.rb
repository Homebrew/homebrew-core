class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.11.1/libfabric-1.11.1.tar.bz2"
  sha256 "a72a7dac6322bed09ef1af33bcade3024ca5847a1e9c8fa369da6ab879111fe7"
  license any_of: ["BSD-2-Clause", "GPL-2.0-only"]
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "8aa0b77f4999eb110de1a377250b2aa82dc719a07f33197dc5041f257a64e668" => :catalina
    sha256 "0c297a2011336eb7e1b4273d7f204888b1c7d22e24ae6354676822b912874bfe" => :mojave
    sha256 "897aa5456f78ee765d586c3a249c75f4f96178de847c09a4ce45834701236903" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "provider: sockets", shell_output("#{bin}/fi_info")
  end
end
