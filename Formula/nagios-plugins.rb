class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.3/nagios-plugins-2.4.3.tar.gz"
  sha256 "cb210e6ea037181b15ad85e17b98f70415be7334d0607aef712fb7d1a1c62aaf"
  license "GPL-3.0-or-later"
  head "https://github.com/nagios-plugins/nagios-plugins.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "63ee1204cec7047eed4b5918b050f7c4b967c3da5e16870ed9bea02a05555d97"
    sha256 cellar: :any, arm64_monterey: "52a9da57c6482d6db104d60111b65232e4c634328ed22d2ee37ccc02c850e6c5"
    sha256 cellar: :any, arm64_big_sur:  "966e9d28573f5e197ce9dae6f86ad5459a3af4aef54380b0639649925bac39a4"
    sha256 cellar: :any, ventura:        "5160ba69a59c03858756ef81c665cb5df1e9357e8cd6c5c1f21e1414f4248d60"
    sha256 cellar: :any, monterey:       "59d48c969aafa22d69f8aff8761c41784f97cb09bc93ca99c897239ba2f77344"
    sha256 cellar: :any, big_sur:        "3086d491e7bb155e149fcf7cf8266f249ff34776e0e42d53a02fc7f9fc0bd865"
    sha256               x86_64_linux:   "06553b8d5727460be7a4b20a52ac714d4a5cc2997c7c779b660eee4ed117653a"
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
