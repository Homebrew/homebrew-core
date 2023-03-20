class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.3/nagios-plugins-2.4.3.tar.gz"
  sha256 "cb210e6ea037181b15ad85e17b98f70415be7334d0607aef712fb7d1a1c62aaf"
  license "GPL-3.0-or-later"
  head "https://github.com/nagios-plugins/nagios-plugins.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "43a9d1d5eb86b6acabf2f160a686e5498fbff4cdc0de62568af2bdd98897939e"
    sha256 cellar: :any, arm64_monterey: "9ef5dd8a0cd8af4971d13489786b37e34e2c19d80d477c81a0b7daf97bf87387"
    sha256 cellar: :any, arm64_big_sur:  "29e6ccd18dfe1e41952ca10a0f62fb21fe13a2c524be8bfbecce372a068f2bff"
    sha256 cellar: :any, ventura:        "cdd09933e8e53624dc05d83afb7033ba4ec20722faa595166b97ed740866946e"
    sha256 cellar: :any, monterey:       "d1ec2d9ab16dacc476bffd52296bb9703c6457f187dc3720b4b334cf8319eb72"
    sha256 cellar: :any, big_sur:        "a1e7a1f63e645dba0c33231ab053fd2ef67366ca4836f5a76178585a045f3f2f"
    sha256               x86_64_linux:   "bae16216eb65550deac5f0c373870f541e745832e49dae4e99bcc2a722a26fe5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "bind"
  end

  conflicts_with "monitoring-plugins", because: "both install their plugins to the same folder"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --libexecdir=#{libexec}/sbin
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
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
