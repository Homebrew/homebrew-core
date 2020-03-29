class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz"
  sha256 "07859071632ded58c5135d613438137022232da75f8bdc1687f3f75da2fe597f"
  head "https://github.com/nagios-plugins/nagios-plugins.git"

  bottle do
    cellar :any
    sha256 "b90c6f268ed5a5310a797855d87730f016c5d5077fa7b131c929aee042a1ee6c" => :catalina
    sha256 "9dc95d628b0ca0e63df426e933f2be374442fa6ea3c6db0ea24ffb5967d098b1" => :mojave
    sha256 "873811a29453153cd0ace61f92be73ae33b4a5bec1a4ece13baf128b32250e6e" => :high_sierra
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
