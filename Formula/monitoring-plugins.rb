class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-2.2.tar.gz"
  sha256 "296a538f00a9cbef7f528ff2d43af357a44b384dc98a32389a675b62a6dd3665"
  revision 1

  bottle do
    cellar :any
    sha256 "3aa775909751c2a826325b07f0a9b77df5160af6bacfa4f8cb082e635045c620" => :mojave
    sha256 "81f794e4736584eba6ecfc32b6c79b877579b3841e66b9f70754f98c499a5098" => :high_sierra
    sha256 "0fa42fdf9687faa06a7566322cf9014d06040338e5a988da6aef130b15e2953a" => :sierra
  end

  depends_on "openssl@1.1"

  conflicts_with "nagios-plugins", :because => "nagios-plugins ships their plugins to the same folder."

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
