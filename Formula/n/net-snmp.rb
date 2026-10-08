class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.9.5.2/net-snmp-5.9.5.2.tar.gz"
  sha256 "16707719f833184a4b72835dac359ae188123b06b5e42817c00790d7dc1384bf"
  license all_of: ["MIT-CMU", "MIT", "BSD-3-Clause"]
  revision 2
  compatibility_version 1
  head "https://github.com/net-snmp/net-snmp.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/net-snmp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_golden_gate: "359759cc4d5243c1b00718b3a243f2628830dca23386cf01a1f88c14ec2d2f69"
    sha256 arm64_tahoe:       "ea1257eafed4f0743dbd5ee1858711b162e5b9e222af987f67343eb638cb4551"
    sha256 arm64_sequoia:     "d3fe01e57a8647bde0f85fb29e6584dd2bb5468e732583317e69532990844918"
    sha256 arm64_linux:       "3092a0a9ddcd531672934f6c546c5b239d042132b7aee0ca290d9194e42b5245"
    sha256 x86_64_linux:      "ca797f3ee39ab466a424eb17e3ae1a0a3a4a670392537c849f5b0c3cf061884c"
  end

  keg_only :provided_by_macos

  depends_on "openssl@4"

  on_arm do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Fix -flat_namespace being used on x86_64 Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
  end

  # Apply Debian patch to fix link failure: undefined reference to `run_shell_command'
  patch do
    on_linux do
      url "https://salsa.debian.org/debian/net-snmp/-/raw/27ec8dbccda7b9b2f78f38445b5735f0398384f3/debian/patches/makefile_trap_needs_agent"
      sha256 "b884acb45f79ab324fb31faa5a3a97bf7ced948177a2d888af9df8dd355aa6de"
      type :unofficial
      resolves "https://github.com/net-snmp/net-snmp/issues/434"
    end
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
      "--with-openssl=#{formula_opt_prefix("openssl@4")}",
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
