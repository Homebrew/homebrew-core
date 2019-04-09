class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz"
  sha256 "647c0ba4583d891c965fc29b77c4ccfeccc21f409fdf259cb8af52cb39c21e18"

  bottle do
    sha256 "27cfda8fe9e205ff63eda487821e13d93b19900838b4ad0ebd73a86fc8c7224b" => :mojave
    sha256 "d8f55e381e65df1be3113923dc351fac227ae17b6334a9d2c939cf346434eca9" => :high_sierra
    sha256 "f88a0ce6fd30f875cc9654f3989b0728d2bd230e09bec994cdb8c2461a7f2166" => :sierra
    sha256 "d9920741a2e4322d7c9fd55a87f3d7bf56f4abfa3a49f0fc9adcf408f891775a" => :el_capitan
    sha256 "1fcf4d4934fe7f7793fb78d13f17f948d46a19600e02881b22695f736f327e65" => :yosemite
  end

  depends_on "openssl"

  conflicts_with "monitoring-plugins", :because => "monitoring-plugins ships their plugins to the same folder."

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl"].opt_prefix}
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
    assert_match "google-public-dns", output
  end
end
