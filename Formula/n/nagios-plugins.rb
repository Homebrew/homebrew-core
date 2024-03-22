class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.9/nagios-plugins-2.4.9.tar.gz"
  sha256 "74da12037c0ab62ad34f9d9f00f475c472cef0913d2ffa9810c17fef101cd5cf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "1bc2096c34e80cd6e6ba595c3246f71dffa2ed38ab9f62d0090eec97d17a7a5c"
    sha256 arm64_ventura:  "365b9b21999f7f4541bb41af1f6cc9c72456c3bffd433eaaee25caba523a9575"
    sha256 arm64_monterey: "6f1cc6d7d49040b4a7475f97661c3810d04996d7b6e46b42667a7b9d14601c7f"
    sha256 sonoma:         "928eaceb0fae5b7bf1373125867cf07786b6ecbd2b6ababcd9ccc9524b948c29"
    sha256 ventura:        "bbdfe7c21bc9947ebb1d22e456ff84570f7842a34e3e50c549122d9564349b01"
    sha256 monterey:       "74afc77720ec9152145b8a9db9c5009450b99d88e61fedaba78690bffbd5a6d6"
    sha256 x86_64_linux:   "278a9d1c126545003bd5933b9926c8f74929bae0540d84a86b158914d117bb58"
  end

  depends_on "gettext"
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
