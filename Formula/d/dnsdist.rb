class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.1.tar.bz2"
  sha256 "4b1db4fae2917e54a804440580a602db3300aed7801f6c986bf03ba7768bc01a"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "23fbc0644271120a1586abc35dd527006ef0a58b39e0ebfc0f583395a54fb8e2"
    sha256 cellar: :any,                 arm64_ventura:  "8ae6f97a60710d478b3409b39d1e3764cf8b2fb7e61b97cdf2cbd36a2fffdd78"
    sha256 cellar: :any,                 arm64_monterey: "4a6bae822ce498ec699aa29b5c191cb7c6c2cd02ce164999be32695a9ea7e126"
    sha256 cellar: :any,                 sonoma:         "71eab7f58ad71aecb9363033489c0608cc05961f7dfe06cc9c61901deecf0338"
    sha256 cellar: :any,                 ventura:        "c34ea7402f1d244df1c0fa70804919054753a584150d86520a30692f29046b46"
    sha256 cellar: :any,                 monterey:       "4bab48704b9600f642e76062f120042308d9cc24b4eb8ffc7bb6de630e9e5da0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fde8b647887a2f4b8c606445852469c63fce7b828d1c11bdab87d78824588299"
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
