class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.4.tar.bz2"
  sha256 "297d3a3751af4650665c9d3890a1d5a7a0467175f2c8607d0d5980e3fd67ef14"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d8ee4889448db1237e2ee4df06ab634e007e792f6b7fe5483967d3b6a1fb6162"
    sha256 cellar: :any,                 arm64_ventura:  "4d44d8f158148ef5f21f03300cc9fc83c683486870c6f16e70350fba8c4e129c"
    sha256 cellar: :any,                 arm64_monterey: "82187fc9875494dc900729b730a82d3fafff12a68415519abb0d09a0e66b4dd4"
    sha256 cellar: :any,                 sonoma:         "89dae2330691f0396317491c5e6dc693c86e4fc9bd0733d6ec130b05b91ae501"
    sha256 cellar: :any,                 ventura:        "1c2fab271a1fe8c7a8e099a206e09711994f16696383c50d754c20d434daccfa"
    sha256 cellar: :any,                 monterey:       "e2366d3622d7f6e258990414416a17d9b1c069acc8570deb0ded86838816c47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b30f1efc08e67fdf63aaa82b3ae1cf7099481de6d9511be0fa632be2bd94d821"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"

  uses_from_macos "libedit"

  fails_with gcc: "5"

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
