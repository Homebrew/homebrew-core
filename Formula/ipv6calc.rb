class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "http://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/0.99.2.tar.gz"
  sha256 "f2eeec1b8d8626756f2cb9c461e9d1db20affccf582d43ded439bdb2d12646ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ccbbf74bb739f03f508b3b9de284a976deb6d812b162ee8993950537503ca18" => :sierra
    sha256 "437b1ccd14d570eed3f5aefc6136921fecf64a6e5271342b56f265436562f610" => :el_capitan
    sha256 "07aaa189403bd9d01a12e5aa79e8447e6f182cc6ef1ddcd68d5a9588cd6dd435" => :yosemite
    sha256 "7b3518dc5a1a0e9d8804b2d3e231b271f112569f61ae816f3649ca2ba55b9168" => :mavericks
  end

  patch do
    url "https://github.com/pbiering/ipv6calc/commit/128cb3b178dde1b9bcadc1b7a334c5eebcc529be.patch"
    sha256 "3148380d4aba3b50150597ec209a1cf7aca7091d3be5f57a2e517445cb55430c"
  end

  def install
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97", shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
