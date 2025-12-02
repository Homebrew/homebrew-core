class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.9.4/net-snmp-5.9.4.tar.gz"
  sha256 "8b4de01391e74e3c7014beb43961a2d6d6fa03acc34280b9585f4930745b0544"
  license all_of: ["MIT-CMU", "MIT", "BSD-3-Clause"]
  head "https://github.com/net-snmp/net-snmp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/net-snmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "70ede4b399566e2fd69c1398aa9a4eb138c83d525591191e1537e149a872ffa5"
    sha256 arm64_sequoia: "286c0ab3464504fb8885d639f320322b6f3d0cdbf65e9d937faee59d6683ae9c"
    sha256 arm64_sonoma:  "73f74299a8bd62a0581ac858fb2187e7116404a3fef0ce1073b836b41474cef0"
    sha256 sonoma:        "5f3604e5b1f7c75a6d250cabb9f3d8593308d892171162caa6a69322b0d462c4"
    sha256 arm64_linux:   "bb3a1b67ac43dac652a9fc430ce99658aa990944bf96856e6cc502b7ded32398"
    sha256 x86_64_linux:  "980d129bddaf44e003db583f94210d8e1b01b4b236b8a4a2188671c66f033286"
  end

  keg_only :provided_by_macos

  depends_on "openssl@3"

  on_arm do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fix -flat_namespace being used on x86_64 Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    args = [
      "--disable-debugging",
      "--enable-ipv6",
      "--with-defaults",
      "--with-persistent-directory=#{var}/db/net-snmp",
      "--with-logfile=#{var}/log/snmpd.log",
      "--with-mib-modules=host ucd-snmp/diskio",
      "--without-rpm",
      "--without-kmem-usage",
      "--disable-embedded-perl",
      "--without-perl-modules",
      "--with-openssl=#{Formula["openssl@3"].opt_prefix}",
    ]

    system "autoreconf", "--force", "--install", "--verbose" if Hardware::CPU.arm?
    system "./configure", *args, *std_configure_args
    system "make"
    # Work around snmptrapd.c:(.text+0x1e0): undefined reference to `dropauth'
    ENV.deparallelize if OS.linux?
    system "make", "install"

    (var/"db/net-snmp").mkpath
    (var/"log").mkpath
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snmpwalk -V 2>&1")
  end
end
