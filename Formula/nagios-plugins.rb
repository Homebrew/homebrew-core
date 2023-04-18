class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.4/nagios-plugins-2.4.4.tar.gz"
  sha256 "9eb151c0665b4a9b8fbe0baf95656312e1c830fb1de7fa58aed358972b51c25d"
  license "GPL-3.0-or-later"
  head "https://github.com/nagios-plugins/nagios-plugins.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "ac704404050b946572798e86190a2ea8d79858fc97d5396784ab84d0a5ed57fb"
    sha256 cellar: :any, arm64_monterey: "9ab2044cf7d911c36254984e8b234a42fa24cb7154a44ade6dd9aef0084ecd34"
    sha256 cellar: :any, arm64_big_sur:  "fde50c7f5f92c4bf8727b11f5af77abbc6b8cd9d9bd20e43805c4972031d0742"
    sha256 cellar: :any, ventura:        "649d139a4085c5196d85622e0b5041246852159f1c2bc5828877580a09e25f32"
    sha256 cellar: :any, monterey:       "96ee1e6041863ee1aac4e3e08c8d36f4ebebeed41503979ab6f440ba3aa97f7a"
    sha256 cellar: :any, big_sur:        "385cf060c743e8a33a50c056593b44c8801939c7020969115b0a9da3ff176432"
    sha256               x86_64_linux:   "fe7889b27102a0589fb45aad41f80c4110aee1b6c32dd51d37d2e713178286bb"
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
