class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-3.0.3.tar.gz"
  sha256 "a1df32ef4791defd5418907b54be1549c81598fd02e339c4595d2d26107b3280"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://github.com/monitoring-plugins/monitoring-plugins"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "a7c52cb5aa2883a94632674f9c1da385c3df61f876efb983714477792a9e0334"
    sha256 arm64_tahoe:       "c949d37e61b3d7f3ed660a6889dc83403db7371b23dbe56b5046e790ec9d8443"
    sha256 arm64_sequoia:     "e227db34ff6033f9985616bec73395e2f5ff397916e1e42ce91ce3f876d69d79"
    sha256 arm64_linux:       "f6788742b50736b09a571c0733f38f2b7f884b8a6c971f1414364fe217114979"
    sha256 x86_64_linux:      "5f9570bf8d57e886a792ba905e858a2a795b9c289dad42c007882c66fb319292"
  end

  depends_on "net-snmp"
  depends_on "openssl@4"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "bind"
  end

  conflicts_with "nagios-plugins", because: "both install their plugins to the same folder"

  # Fix check_snmp build at the site upstream missed when renaming `USE_OPENSSL`
  # Fix check_snmp build against net-snmp without the legacy `DEFAULT_SNMP_VERSION` alias
  patch do
    url "https://github.com/monitoring-plugins/monitoring-plugins/commit/09c05ab8d1838c7a39654cfef00eccfc105feb95.patch?full_index=1"
    sha256 "a22583a8802126c2332179231d4f0fbda2c175e44d9830b9c88073624debf9c8"
    type :backport
    resolves "https://github.com/monitoring-plugins/monitoring-plugins/pull/2319"
  end

  # Backport support for OpenSSL 4
  patch do
    file "Patches/monitoring-plugins/openssl-4.0.diff"
    type :backport
    resolves "https://github.com/monitoring-plugins/monitoring-plugins/pull/2326"
  end

  def install
    # workaround for Xcode 14.3
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = %W[
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{formula_opt_prefix("openssl@4")}
      --with-netsnmpconfig-command=#{formula_opt_bin("net-snmp")}/net-snmp-config
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<~EOS
      All plugins have been installed in:
        #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H brew.sh -s 8.8.8.8 -t 3")
    assert_match "DNS OK", output
  end
end
