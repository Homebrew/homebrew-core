class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.8.2.tar.bz2"
  sha256 "6688f09b2c52f9bf935f0769f4ee28dd0760e5622dade7b3f4e6fa3776f07ab8"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "887adf419880d8a9769381d6f2e16e16ed4bd79d9b205b68ac895d2906fe5df5"
    sha256 cellar: :any,                 arm64_monterey: "4f6ed09a29018e237acacd747300805f0f9aa8a711e6da864a22f984789cd8ee"
    sha256 cellar: :any,                 ventura:        "963744f8733a8fd6e0aa16f349d64844f03577d5336176c19cc89a9255503ff9"
    sha256 cellar: :any,                 monterey:       "3a7eadfe040b593fdbb906eb83b2f1d67dfdf34eaa810c5823aba9c68b2c0a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd6e6c071ddd4a5b0a8a154ebefe98127caf93cc8b14640e521de403fdae0172"
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
