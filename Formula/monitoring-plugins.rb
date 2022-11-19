class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-2.3.2.tar.gz"
  sha256 "8d9405baf113a9f25e4fb961d56f9f231da02e3ada0f41dbb0fa4654534f717b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.monitoring-plugins.org/download.html"
    regex(/href=.*?monitoring-plugins[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "83d0666dc9cd070520141f966f4a133eaf8ec40c97add43d25c3b60d1e131bd9"
    sha256 cellar: :any, arm64_monterey: "e6682827d5a6e334847f857104a3415da7c717c3edf725a43f8ee58d0f881737"
    sha256 cellar: :any, arm64_big_sur:  "74484805120e1ef11f5c7696e32cb1fc8828f22ef19787e6c9a0e3df6f6f4911"
    sha256 cellar: :any, monterey:       "4eba8230adf01aa4dc2dabee65866dae5a1b76ce01d878bd39d3e48d12729206"
    sha256 cellar: :any, big_sur:        "a1c9496818852e51b3d8ab83a238d0bd1dc1a42269d6326ed16a5777aafd0529"
    sha256 cellar: :any, catalina:       "b04944bcecebf22f4c5569be031fe50c45bfc51f9d9c82dbfdc55688a8cf7a63"
    sha256               x86_64_linux:   "a09ef343aef085bd6463e4070f3cb3f4b683cfc046bcacfe680c946084c7616d"
  end

  depends_on "openssl@3"

  on_linux do
    depends_on "bind"
  end

  conflicts_with "nagios-plugins", because: "both install their plugins to the same folder"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
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
