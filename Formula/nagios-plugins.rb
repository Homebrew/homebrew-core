class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.1/nagios-plugins-2.4.1.tar.gz"
  sha256 "72327ef2ccc58f5944c09fea1834c130be58200164d2b9fb532b4900e16fee69"
  license "GPL-3.0-or-later"
  head "https://github.com/nagios-plugins/nagios-plugins.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "02e2b947b95e6d78018ae1cd89823c0942b10abc58a635727bab341099ceb846"
    sha256 cellar: :any, arm64_big_sur:  "988fde6184cc5668753a9be452ebcbd86e0ef83c198d5e62ab70f011fecb125f"
    sha256 cellar: :any, monterey:       "cd3d58e3c2e950127f4c11764c4bdb9a703de30abba0affd1420fa9ff07aa40f"
    sha256 cellar: :any, big_sur:        "d67f48bc371446e698c1d33da6f42efcf857983935eab43dc13941721d27e674"
    sha256 cellar: :any, catalina:       "87618b9f9d907e005765c8b2e2504263002cd971df1f4f444c325a7799d52bfc"
    sha256               x86_64_linux:   "a3b4c3adb6e9fd63f8f80b4e32092de041a47507230d310309c0f2339b6d55ec"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "bind"
  end

  conflicts_with "monitoring-plugins", because: "both install their plugins to the same folder"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

    system "./tools/setup" if build.head?
    system "./configure", *args
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
