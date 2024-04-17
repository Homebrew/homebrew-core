class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.3.tar.bz2"
  sha256 "f05b68806dc6c4d207b1fadb7ec715c3e0d28d893a8b3b92d58297c4ceb56c3f"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "20e6987aec8bfaa55b2b776fccf5672dbdb0d91de79a10ee4025608fc1f2db17"
    sha256 cellar: :any,                 arm64_ventura:  "93c4d5018b5dac723c27d9e0ef49739e6d60ae33e2d83245b656872cd4c099d7"
    sha256 cellar: :any,                 arm64_monterey: "d1120439da992fa8b6a93ced426ba8c96134efd3714871584559812f67cafbe8"
    sha256 cellar: :any,                 sonoma:         "c4b69412449af4e07c00392f612e5aa1745ec4f06b4d9272dd70c3b37c99979d"
    sha256 cellar: :any,                 ventura:        "86b17ca4d74e5eb944941832fadaa6484b9edf911ff66bba370bb8d0f730c510"
    sha256 cellar: :any,                 monterey:       "27e917beb812ac1162598acbe8660f93b697d6d7df0e156718b45da43b1add5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf452f424e6187463af07b5955ec0eaf757d85925df8f7282644169f820b0c0e"
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
