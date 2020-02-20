class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.3.2.tar.gz"
  sha256 "b074c27a4a2bb08bae30c724b28c1f33f2c5f37dc4b0c5dad0171ca39356a5c9"
  head "https://github.com/nagios-plugins/nagios-plugins.git"

  bottle do
    cellar :any
    sha256 "8678eb2f59ee4a4a2e2fbce1fac118a417d3425d7a61153ab3e8d595f40ab540" => :catalina
    sha256 "bd7d15750d00a4b75d6e8c0b2fe75a5e508c00ab832c206e4cf017d53c793c68" => :mojave
    sha256 "14e25d0a27df813595c6060767fb9e24545efe6065f6c15e2b27d3f5e704c449" => :high_sierra
    sha256 "4119699bb703aea5a3a9369300b209587209c4d8675d22997a16ed75089e141b" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  conflicts_with "monitoring-plugins", :because => "monitoring-plugins ships their plugins to the same folder."

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
