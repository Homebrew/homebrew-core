class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.9.5.2/net-snmp-5.9.5.2.tar.gz"
  sha256 "16707719f833184a4b72835dac359ae188123b06b5e42817c00790d7dc1384bf"
  license all_of: ["MIT-CMU", "MIT", "BSD-3-Clause"]
  head "https://github.com/net-snmp/net-snmp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/net-snmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "aa3127d38dc1d35626fe7bd3e53e66bd88adea6ed7aca814ba55adbe47b7fabb"
    sha256 arm64_sequoia: "6a1db83d132177a261003a10ad4f9392ef532b0eade1b831af53d2cf388c5d20"
    sha256 arm64_sonoma:  "43a5e2de2d18ee41c5517bd121f28881a2b5add0935277dd749704866d58fde5"
    sha256 sonoma:        "0ef82db8c6d4236ce288931fcc5529632f3b9fdd6bc10eb7a77f1fe54d0e3cca"
    sha256 arm64_linux:   "0ff9a48126694d8c8eac3e6a7d01bd013cb22db2e88b8cc91135fe3f0eec1c26"
    sha256 x86_64_linux:  "1105287f2a864a6c66b750dae9ba98d7a6fae7a30a1a729a6c3d47cb88ac6d54"
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
