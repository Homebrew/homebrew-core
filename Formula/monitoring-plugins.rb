class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-2.3.1.tar.gz"
  sha256 "f56eb84871983fd719247249e3532228b37e2efaae657a3979bd14ac1f84a35b"

  livecheck do
    url "https://www.monitoring-plugins.org/download.html"
    regex(/href=.*?monitoring-plugins[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "0d28c059618baac62c5d3a3703eba0196f0a38785241ef2cdaae20627ef05bd2"
    sha256 cellar: :any, arm64_big_sur:  "5044511cc0f5a64f3424d4507559b6ca316669121f4b15d58ef6b9cec5bba3f8"
    sha256 cellar: :any, monterey:       "02d82e44495dd015a29e9680e4ad4d82d9bc31708eb179186b399c56cc22d74b"
    sha256 cellar: :any, big_sur:        "a49576ad287d073c67e0da12be686ba737abe34e5f61813a2e308cd44c427017"
    sha256 cellar: :any, catalina:       "644b33de5338e00a2103c87aa4b55a39b7a16e2ecee49936f2251a0a97756f0f"
    sha256 cellar: :any, mojave:         "883707c4b2fe29a6d0b8453d4d19005128761d5d6952b9fe21292ec4b4cb2b11"
    sha256               x86_64_linux:   "db7cde1c3eb426811fd9ecec4a97c485caad9a35800d8006123339d0b82963b6"
  end

  depends_on "openssl@1.1"

  on_linux do
    depends_on "bind"
  end

  conflicts_with "nagios-plugins", because: "both install their plugins to the same folder"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@1.1"].opt_prefix}
    ]

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
    output = shell_output("#{sbin}/check_dns -H 8.8.8.8 -t 3")
    assert_match "DNS OK", output
  end
end
