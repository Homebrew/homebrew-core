class MonitoringPlugins < Formula
  desc "Plugins for nagios compatible monitoring systems"
  homepage "https://www.monitoring-plugins.org"
  url "https://www.monitoring-plugins.org/download/monitoring-plugins-2.2.tar.gz"
  sha256 "296a538f00a9cbef7f528ff2d43af357a44b384dc98a32389a675b62a6dd3665"

  bottle do
    sha256 "39310e6fcfee83275afc1ceab922e4f2a8c72306bf54af49aed986c658175a82" => :high_sierra
    sha256 "426c87771bcb45bbc92755ea4b05ee213863423554c8bb21b9e2fdfd5e32e959" => :sierra
    sha256 "d531079a00f1dae22309918b9fbbd3250873b5869001f14af1d221d5bb7b021b" => :el_capitan
    sha256 "b3d0549fc51c3948743b16eb5bc52a0a7f8af6cf6ad6c05b3056fa947661a6da" => :yosemite
  end

  depends_on "openssl"
  depends_on "postgresql" => :optional
  depends_on "mysql" => :optional

  conflicts_with "nagios-plugins", :because => "nagios-plugins ships their plugins to the same folder."

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
