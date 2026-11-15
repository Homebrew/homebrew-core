class Lldpd < Formula
  desc "Implementation of IEEE 802.1ab (LLDP)"
  homepage "https://lldpd.github.io/"
  url "https://media.bernat.ch/files/lldpd/lldpd-1.0.23.tar.gz"
  sha256 "b65fc380e2063a3fb15555f413f192a63006f6fd0c81fd524e3a43851700c48b"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?lldpd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "a6939ddbd23ca53ca3d3bd5fe6bb26b88cd5e4022bd445b967a643f7ed212fa9"
    sha256 arm64_tahoe:       "9f71abb7d2b6582ed9de6267a79737660f809bbb1d824eec34da54d3b8a703be"
    sha256 arm64_sequoia:     "7401b73ef06fea630c434b4824b48a96c2fa0343c2605bf45e0a8055a44a822e"
    sha256 arm64_linux:       "6a807b6d37dc4c601f294a755f5f8ac73d93f82195106f7d83bc48591cc470df"
    sha256 x86_64_linux:      "c8d08cedb3d25c851217fa421342733b4ee225ec3d5b0f388d7bb554986268d1"
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "readline"

  uses_from_macos "libxml2"

  deny_network_access!

  def install
    rm_r("libevent")

    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --with-privsep-chroot=/var/empty
      --with-privsep-group=nogroup
      --with-privsep-user=nobody
      --with-readline
      --with-xml
      --without-launchddaemonsdir
      --without-snmp
    ]

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    (var/"run").mkpath
  end

  service do
    run opt_sbin/"lldpd"
    keep_alive true
    require_root true
  end

  test do
    output = shell_output("#{sbin}/lldpcli -u #{testpath}/lldpd.socket show neighbors 2>&1", 1)
    assert_match "unable to connect to socket #{testpath}/lldpd.socket", output
  end
end
