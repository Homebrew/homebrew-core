class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.8.0.tar.bz2"
  sha256 "1c0d375c25453d349b88e03ff589aa2603ca8692fc98364c068ead372804704f"
  license "GPL-2.0-only"
  revision 2

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bcdcbf3481715212f7e08ecd4ba643b6b49ef0f284155b15101a4deb46ef572b"
    sha256 cellar: :any,                 arm64_monterey: "d1523bc0741fec73483d5d97d646b494725b06a9df3cb210ea670850368aa6e7"
    sha256 cellar: :any,                 arm64_big_sur:  "68b519a35fe9f68622db48dcf068c97c65c7fbcb47f2290a34728b00f6e34891"
    sha256 cellar: :any,                 ventura:        "383c9920efbc55782f3e579544b1c31758513f4a07d8e0911e259992cd19aa30"
    sha256 cellar: :any,                 monterey:       "6c1cd8b38d8a79261a47be1567f9b8133bfd806169c7701374352382e8fe3d90"
    sha256 cellar: :any,                 big_sur:        "f0e75d49e95e926f612fe49d72c93e5709cb6916aac804e70357c8ef8ac80512"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5de363e7cd6bc0475a64909ed04ea72e7cb0a0cba89c615dde510dc0b24215dc"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

  fails_with gcc: "5"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-net-snmp",
                          "--enable-dns-over-tls",
                          "--enable-dns-over-https",
                          "--enable-dnscrypt",
                          "--with-re2",
                          "--sysconfdir=#{etc}/dnsdist"
    system "make", "install"
  end

  test do
    (testpath/"dnsdist.conf").write "setLocal('127.0.0.1')"
    output = shell_output("#{bin}/dnsdist -C dnsdist.conf --check-config 2>&1")
    assert_equal "Configuration 'dnsdist.conf' OK!", output.chomp
  end
end
