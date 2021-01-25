class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-2.3.tar.gz"
  sha256 "3fd96efaa751c7646fe3ba25f9714859a204176a155d12fe0ee420e39e90f56c"

  bottle do
    cellar :any
    sha256 "2affcbde085b468167dbc0806e2b328b2ce8e155e08369e4df0d968e2568723d" => :big_sur
    sha256 "e96b7ab01d8202e55df025b8570d42d338241b828ede6c2f4eda0f9681fe0b1b" => :arm64_big_sur
    sha256 "918135f3648b566cfa9908d0fbbd65079d0a3c0c8794167aebe43aa2dd739fe7" => :catalina
    sha256 "c98c17126372176090c58eef202309972dc44f1d34be28ffc96c30a37d3f3217" => :mojave
  end

  depends_on "openssl@1.1"

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
