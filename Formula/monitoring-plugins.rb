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
    sha256 cellar: :any, arm64_ventura:  "9e9f87e7eb037bd0817d36d110d91125bb948e695e3ac6393be3f4169e6ce245"
    sha256 cellar: :any, arm64_monterey: "71224ec92ab3485fc0a43c482a43d8dce1d696f5fa533390a2be5fe650d00b94"
    sha256 cellar: :any, arm64_big_sur:  "c06061c9dec5d2be2d293dd4fc5711d4433918091f2938931aeb47e37fe4dfe9"
    sha256 cellar: :any, monterey:       "80c23a96cd8a13ddea25d9d91a2cbca698b6f746a28437cec096118b372f71b8"
    sha256 cellar: :any, big_sur:        "73e2d72fbf174875c19c90c7d64968921b604b7c3702cb908c3f3706e457777a"
    sha256 cellar: :any, catalina:       "e181e7c50c4ecc1ae086cde6d8e12b28b148bfe6925cd2c6455bdf3d07e753e2"
    sha256               x86_64_linux:   "d042858d2176f3c6256be7454134ef2000808e3be02dbd83e9818b6a442bfe4c"
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
