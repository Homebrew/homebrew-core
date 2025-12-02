class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-2.4.0.tar.gz"
  sha256 "e5dfd4ad8fde0a40da50aab3aff6d9a27020b8f283e332bc4da6ef9914f4028c"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.monitoring-plugins.org/download.html"
    regex(/href=.*?monitoring-plugins[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "e611a641792258e275bfcf3d98669753a3740e5815ccfb6c7e0ef1cc104a13f4"
    sha256 cellar: :any, arm64_sequoia:  "3e652bea8db767df61aa87f55194af9a9a181272681ddf7300ee4a8d5dde3468"
    sha256 cellar: :any, arm64_sonoma:   "f8eee9b8e4b8300633bd73e365aa6e2daffcca7a58962ef7f20064b1bb378e12"
    sha256 cellar: :any, arm64_ventura:  "0a6a841f7d31c47c25418a08bcbe3622e95ec5a9cdc31aef8f95c7630c64f3fd"
    sha256 cellar: :any, arm64_monterey: "a5d15e7a30db8d11d30973cd12985e6fb62f95fa74c73696d960912f52492e40"
    sha256 cellar: :any, sonoma:         "8e139e077e10f664e33c4dafa4bc404d6bf47bcf1e82bfa5c1a8daa481a85af3"
    sha256 cellar: :any, ventura:        "3407ba5eda8acc2806ab7eec27af3f339852b857cf935954fca1c7ab38c75bf0"
    sha256 cellar: :any, monterey:       "6879fa228c284f01e3688078e66b7a0374012e37147183cfa08c5d9ff1b0e47e"
    sha256               arm64_linux:    "2caa7d52925b286737f83a15a800de15edbbc4d280756b9ab268cd4e810b42ba"
    sha256               x86_64_linux:   "27b58371aa6e210a9510c9fd0b64ed2f0923425b336eeda2b5c9eb0fd08509ac"
  end

  depends_on "openssl@3"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "bind"
  end

  conflicts_with "nagios-plugins", because: "both install their plugins to the same folder"

  def install
    # workaround for Xcode 14.3
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = %W[
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
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
