class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.10.tar.bz2"
  sha256 "027ddbdee695c5a59728057bfc41c5b1a691fa1c7a5e89278b09f355325fbed6"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4326a0e48ec81a1666c0cf67aaebb42323dfecb17a11ec3e615cf17074c111ff"
    sha256 cellar: :any,                 arm64_sonoma:  "fdd547fa3ceac6347b166c150b3bb0981e49456f1dd04c06b444b0f8a29b3963"
    sha256 cellar: :any,                 arm64_ventura: "c52a6888b17889d85a0b9a718d28b4de1aa9eb0ca0aa347dcc40b78ce735321c"
    sha256 cellar: :any,                 sonoma:        "6ae14f11e16e82e9f23acba5b6fe619e5abf9007e1f32739afeca7c6df1d5879"
    sha256 cellar: :any,                 ventura:       "3983ee1c08adeda2ffd318b38c22f12e6a7fe9d5b4701c54abd8fef7c704d59e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16d9920dd7e040347fc099abd41f163f20dce61fe342711b0f9550b10c55cb27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e352136b56de6837cc5901369230a0a0d57f29d967ad6e3725c9bd9dcf632a2"
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
