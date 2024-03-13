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
    sha256 cellar: :any,                 arm64_sonoma:   "0312c3638d489b79806db8c688340fbf271a719e4c357495384afe0c05ebf1b1"
    sha256 cellar: :any,                 arm64_ventura:  "0d65fae66ffe15994372ba985f3445023ed3d255b4da5739259dc36d6b85dfcd"
    sha256 cellar: :any,                 arm64_monterey: "59c30a4a189d462688236d6f814ed4f9b246fc4d7e20efd2d107739823518fd8"
    sha256 cellar: :any,                 sonoma:         "d0f019351fd5847cc186f546f8760c50b4b2379a36c18ac713a5293b66fefd7e"
    sha256 cellar: :any,                 ventura:        "b4dcdde8b947d798c22bac8690970858f2b19a6215213bed45a9ad37a9f9b442"
    sha256 cellar: :any,                 monterey:       "4493355803c28d88eae473121b692ce655490732daa7394644c280e1c7519c38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dfd1cabf3980f3efdcf17776865f134d487a65adf2e092ae13104b8c1a9dcf2e"
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
