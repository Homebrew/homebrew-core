class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.7.3.tar.bz2"
  sha256 "7eaf6fac2f26565c5d8658d42a213799e05f4d3bc68e7c716e7174df41315886"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c4d65f10359eab43970c34d46faf4b0d6a3d41c4d92a78ac6ff19467cb9acdc3"
    sha256 cellar: :any,                 arm64_monterey: "0f7aecead6e27dc1c2807a76ab7f8a37eceee2f3c41a197b4b78651900edfc96"
    sha256 cellar: :any,                 arm64_big_sur:  "174c4cb6f4952f7fbb4f94c5c8ef4b42069134b1e0bd7a0f7f4d0a21e9ec80b0"
    sha256 cellar: :any,                 ventura:        "22d6a2d33298b1a7cf41cbba83946571ef343021c95d09d6f29e27c4561abd0a"
    sha256 cellar: :any,                 monterey:       "90933cf68e3090800c8d3198f907e9dc559e3ab879f507c87d199397db07b6f7"
    sha256 cellar: :any,                 big_sur:        "334533a0ac8cae2f8f6c06b729ad7746697a7b68a545352a813dc56df26654bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7afb19ba1959f023005234423c428823f94b0d18ec11852c9ff14a56044176c2"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "cdb"
  depends_on "fstrm"
  depends_on "h2o"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@1.1"
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
