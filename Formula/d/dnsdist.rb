class Dnsdist < Formula
  desc "Highly DNS-, DoS- and abuse-aware loadbalancer"
  homepage "https://www.dnsdist.org/"
  url "https://downloads.powerdns.com/releases/dnsdist-1.9.7.tar.bz2"
  sha256 "285111c2b7dff6bc8a2407106a51c365cc5bf5e6287fe459a29b396c74620332"
  license "GPL-2.0-only"

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?dnsdist[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cab9add17f959e5a0c37cb16161a8276254a1ae95a9ee451fca72444783f58f8"
    sha256 cellar: :any,                 arm64_sonoma:  "3613abc48b829688f50b7a417968efa9886c18307615a9145ab38b86a06f51fa"
    sha256 cellar: :any,                 arm64_ventura: "3643541508b1a3edfc6fcef8eb257b95653081176452368f2d1da6a7b89e7623"
    sha256 cellar: :any,                 sonoma:        "08e868d21ca368c82493927677fc4a563761b671bda573cc039ec4fddafb94d2"
    sha256 cellar: :any,                 ventura:       "3763357c02a74c2bba45d5a1172dd6f93ab7ca16d53a90f96f804da2e2e8ef4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b3314eadd5faf6e1ced56b990ef519675a70cad7f6a625e1ae40c4b61654e52"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "fstrm"
  depends_on "libnghttp2"
  depends_on "libsodium"
  depends_on "luajit"
  depends_on "openssl@3"
  depends_on "re2"
  depends_on "tinycdb"

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
