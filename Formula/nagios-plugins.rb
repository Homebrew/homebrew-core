class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://www.nagios-plugins.org/download/nagios-plugins-2.2.1.tar.gz"
  sha256 "647c0ba4583d891c965fc29b77c4ccfeccc21f409fdf259cb8af52cb39c21e18"

  bottle do
    sha256 "33f3ad7bc229a5c98a91f1dc60fc5e113afdccb63e3e0c824c631062403c91ac" => :sierra
    sha256 "8a45819e58f06a9cea8f34d2f13d79c22a73ea6fa77eef231681127b6227185a" => :el_capitan
    sha256 "1cf4050b3043c6f74ccadb02ccdfe7b438994bfafad3758eafe625a7539c19db" => :yosemite
  end

  depends_on "openssl"
  depends_on "postgresql" => :optional
  depends_on :mysql => :optional

  conflicts_with "monitoring-plugins", :because => "monitoring-plugins ships their plugins to the same folder."

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl"].opt_prefix}
    ]

    args << "--with-pgsql=#{Formula["postgresql"].opt_prefix}" if build.with? "postgresql"

    system "./configure", *args
    system "make", "install"
    sbin.write_exec_script Dir["#{libexec}/sbin/*"]
  end

  def caveats
    <<-EOS.undent
    All plugins have been installed in:
      #{HOMEBREW_PREFIX}/sbin
    EOS
  end

  test do
    output = shell_output("#{sbin}/check_dns -H 8.8.8.8 -t 3")
    assert_match "google-public-dns", output
  end
end
