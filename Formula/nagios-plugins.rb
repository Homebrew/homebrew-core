class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.3.2.tar.gz"
  sha256 "b074c27a4a2bb08bae30c724b28c1f33f2c5f37dc4b0c5dad0171ca39356a5c9"
  head "https://github.com/nagios-plugins/nagios-plugins.git"

  bottle do
    cellar :any
    sha256 "eb1f8025571fee03e8e90fa5471248d7a4ce927580a5acdafe1b73b82b2fc526" => :catalina
    sha256 "fefc1034868d6e9e27f760e5d5526f5d7238ae8486a1b24628ce853c9e7e214f" => :mojave
    sha256 "3ff736372de65cfe7b5ab3b07d5c1887f42c42d0034794cf8c3f0fdfbc49cff7" => :high_sierra
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
