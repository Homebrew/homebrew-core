class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-3.0.3.tar.gz"
  sha256 "a1df32ef4791defd5418907b54be1549c81598fd02e339c4595d2d26107b3280"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://github.com/monitoring-plugins/monitoring-plugins"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "4bd874b71c116d54622cbabf83b7be686d41d8550bfeabf2f983e26702785df4"
    sha256 arm64_sequoia: "570398ffd401bf7caa32f38aa68407f105bfab162fd0a9bbfa0a286d6ed12ab7"
    sha256 arm64_sonoma:  "a4e0f31d8f66d0a4a22c763c18c3f1136839f3e20c72c05b8a651d7687d75b95"
    sha256 sonoma:        "2ddd12ad429e24c84c7d12ae0e3eca51f67692711f4e524fb783614c4f7831ae"
    sha256 arm64_linux:   "a60f35ee14cd47a3f50f6fcc302399ad7399373f5011ff998b16a5809484e8cf"
    sha256 x86_64_linux:  "8a96a06ff66e4f6630c79df64aa7c7c1f91e56fba79d75555665c1c03fc196b1"
  end

  depends_on "net-snmp"
  depends_on "openssl@3"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "bind"
  end

  conflicts_with "nagios-plugins", because: "both install their plugins to the same folder"

  # Fix check_snmp build at the site upstream missed when renaming `USE_OPENSSL`
  patch do
    url "https://github.com/monitoring-plugins/monitoring-plugins/commit/b80f5de71eeafd809203da2690aec24d99b381e3.patch?full_index=1"
    sha256 "7450acc000dccf52bcf9be2cd267e0ffc2a89a575eed52bb1a64978339603dbf"
    type :unofficial
    resolves "https://github.com/monitoring-plugins/monitoring-plugins/pull/2319"
  end

  # Fix check_snmp build against net-snmp without the legacy `DEFAULT_SNMP_VERSION` alias
  patch do
    url "https://github.com/monitoring-plugins/monitoring-plugins/commit/717a74ecedad30973a83b3eca1823dbe284c6de5.patch?full_index=1"
    sha256 "e965307e728ee0289be0bcf776f92d4ff241b5373adf773e2299673f72005b3e"
    type :unofficial
    resolves "https://github.com/monitoring-plugins/monitoring-plugins/pull/2319"
  end

  def install
    # workaround for Xcode 14.3
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = %W[
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{formula_opt_prefix("openssl@3")}
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
