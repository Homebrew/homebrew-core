class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.2/nagios-plugins-2.4.2.tar.gz"
  sha256 "5b2769ae3d05559ea76ee296e73cf6e99e7175ad1e7ab3a7582c4a36d4ae3f47"
  license "GPL-3.0-or-later"
  head "https://github.com/nagios-plugins/nagios-plugins.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f2729b87cb23d5ad37af39e0b4696dd818c9520507b2d1528d42649ca06fb44d"
    sha256 cellar: :any, arm64_monterey: "c0fe6bd13cc6fa25c154597a0bb66d245bae9a31c0b7d3f049dedd6d862fe5a6"
    sha256 cellar: :any, arm64_big_sur:  "04f19ceb18f70237980d02e1147c03388a3e84e963427bba51f7c4437b1ed265"
    sha256 cellar: :any, ventura:        "c040f9db0325edfac6fc13f7f9ac08acd96f3a4592fe6006b93bf74e8e802e3f"
    sha256 cellar: :any, monterey:       "7106bc2245c818a345caff133b70650336ce8024859986852874b3b539d1c3fe"
    sha256 cellar: :any, big_sur:        "9f5eba9244658bf95874d96c807f1a6f1decc7e201a8be8f8ba247fbcef4688a"
    sha256 cellar: :any, catalina:       "48b56d823d578b7e7076dfb5c9c58dc58d5f9a1147b8ba6ae8937f0142d504fe"
    sha256               x86_64_linux:   "3eb6d87ae49cde9604837cf5479f36237364c92a1d10e9ee78175398934795bf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "bind"
  end

  conflicts_with "monitoring-plugins", because: "both install their plugins to the same folder"

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
