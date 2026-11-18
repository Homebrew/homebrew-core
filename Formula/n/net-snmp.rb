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
    rebuild 1
    manifest_sha256 "41cbd8c525e3a06d93c0ed0b0bcaf2da17343b026bd4ce31427b55ed9bc2d953"
    sha256 arm64_golden_gate: "032c17b11585c711bd7a76174e77e5ab795792ae67be3f493d0e4ed4b8c7a774"
    sha256 arm64_tahoe:       "1121533b1d075028eeb7e0734b51493c690d58e460f6ae09a58e19d192459af0"
    sha256 arm64_sequoia:     "a26da42979d7ed30a33cca21c09b1b0482a273f496796b65a60b029cd923ff5b"
    sha256 arm64_linux:       "97c2e5058bb6a7ef2f38c3ce78b3d58bb2d8a30a62c0662cc456cb1b67cab213"
    sha256 x86_64_linux:      "e5b975989dc608f543e17cb552ac26077b1e7014798020c92b949629355cf76d"
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

  # Fix reusing a session after it was closed, e.g. a PHP `SNMP` object
  # failing every request after the first with "Can't assign requested address"
  patch do
    url "https://github.com/net-snmp/net-snmp/commit/6a16c2df17e9479de822b42a30dca345c9e746f5.patch?full_index=1"
    sha256 "aa729ad0a91cf2d8ba00c437d88b0179b70fa5ab42f8855735ba1e73c84c099c"
    type :backport
    resolves "https://github.com/net-snmp/net-snmp/issues/1055"
  end

  deny_network_access!

  def install
    openssl_prefix = dep("openssl").opt_prefix
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
      "--with-openssl=#{openssl_prefix}",
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
