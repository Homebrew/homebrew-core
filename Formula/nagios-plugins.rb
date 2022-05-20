class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.0/nagios-plugins-2.4.0.tar.gz"
  sha256 "fb8a5a633295d437464f4e23bc7b7d8d9412cf5c8debe8d70e5c030c6d6ba406"
  license "GPL-3.0-or-later"
  head "https://github.com/nagios-plugins/nagios-plugins.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "d5ebcdf7a2abc41073faad4119cb90ed9904d3ff63a34afd9344e7450191e167"
    sha256 cellar: :any, arm64_big_sur:  "478ec656ea9dd695625484f0461ed2dffd7d71e705a9497beffee5b54c7e8682"
    sha256 cellar: :any, monterey:       "1b4d1d845b23f4c69680da927484216c7b7a22ce25275202d4331407ff3b0163"
    sha256 cellar: :any, big_sur:        "13337b2c683d9a06a857db2390beaa4f3b673fe9fa68149159f864b4d9d1c54e"
    sha256 cellar: :any, catalina:       "6b1f5362dfeef40c945f9d90f03ed741ca0c851ebd69770dd0f9a5716cd09aa3"
    sha256               x86_64_linux:   "c24c8f309d1bec9a929db7c544218865341035ab10cb7fc8ecc961655e0aac10"
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
