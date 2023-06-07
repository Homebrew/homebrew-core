class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.5/nagios-plugins-2.4.5.tar.gz"
  sha256 "fb9e500c81f633136e0a7f9fefbaba9b08eb09e7eeaf30af7d24b0a2c6e05906"
  license "GPL-3.0-or-later"
  head "https://github.com/nagios-plugins/nagios-plugins.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "b06a2355aa17247198b27d0bb98fd851cd9995e02c3dc866bf9cb0c439049bcf"
    sha256 cellar: :any, arm64_monterey: "d310ae65083867d0b1bbcb0d6ae0603526abc6cf5739d881260f6598b861fa5b"
    sha256 cellar: :any, arm64_big_sur:  "31265c968b8a4ff226e0557c93c9224ce93fb98e8413ed384e0f1678be8e40b3"
    sha256 cellar: :any, ventura:        "dbb1ea6626009101df290198aaee963b308064c8d4c6a0546b4beccf1a8e79e0"
    sha256 cellar: :any, monterey:       "1b4f2e81f766a1473f51af9c6fa008d7dac727c34847884032101b909ac4c8f5"
    sha256 cellar: :any, big_sur:        "e23d9f578c6869201195e14aff4f1402192248d7c25e08b5d7a4f4aecb838ec8"
    sha256               x86_64_linux:   "c6a897c2aa5e8d9869fce1dffead132d262cc9598cca7d295ae14ea4cd1614b2"
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
