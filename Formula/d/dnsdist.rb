class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.9.tar.bz2"
  sha256 "e86bc636d4d2dc8bac180ec8cdafbfe5f35229b6005ec15d7510fb6f58b49f5a"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a73dc1b7b52577e052279e557fa6518c49463939fc166cbd36cd8b4b9353e801"
    sha256 cellar: :any,                 arm64_sonoma:  "61ecb524ae7eb13da09003ba59f303ac187c0f618863db1017d55afc2d2c9c04"
    sha256 cellar: :any,                 arm64_ventura: "bb3a7bbbd5fbf16d754418dc368b029c407cbbc620d22af809747be807d314e1"
    sha256 cellar: :any,                 sonoma:        "62c7166340f3fce2a10d11a85b82f08f61f6b9c59307790663b3d2ede21c8c8b"
    sha256 cellar: :any,                 ventura:       "e0fd1cbde4a31acb149bbf155dcd7b832f61edae6a7da1dc69acf4c196bd3483"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "976fd9d3f2689b8988f52953343ffe9cb9c83e57b86ecf84c7b42a5955277e32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42dbdf2e4312b61ace402dac35be28e93f7339e3a587fd0c866dddb73bd708b6"
  end

  depends_on "boost" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "tinycdb"

  uses_from_macos "libedit"

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
