class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.12/nagios-plugins-2.4.12.tar.gz"
  sha256 "9a246245d8270f15759763160c48df5dcdc2af9632733a5238930fde6778b578"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:    "6e751f176edcabbb88a2606c98ec0f3062e717b4b0ab5ffaa0e8d16b9406dc06"
    sha256 arm64_sequoia:  "10c5062b3d3edead969f7e18215628e643a7e71f8fdf5b25806305e767c1b999"
    sha256 arm64_sonoma:   "1617bf68a8d2468f70a4e0e9d46cffee9883578dfa0eddcc1af71463bf55ef12"
    sha256 arm64_ventura:  "2c4c5f8a661d01b36f7fc1a5fc5f4c24971516fc47f907da6818842e26fd51e0"
    sha256 arm64_monterey: "4592b8a1585568faa9129f9b5ca5ff9f2eee674dac8763b684ba721bdacb2635"
    sha256 sonoma:         "3a9c7c79fe4c09d02b7287c16b62d2f3d0870752f538b5e4a57857ba0e745803"
    sha256 ventura:        "2fe347734de901c7483944d7c1538bffb740202f88920a626eccd6ec41c9c35e"
    sha256 monterey:       "735a78ed14375db0a52fc95f6b93f9410f47717250e134d8c19c4c70e6bce23f"
    sha256 arm64_linux:    "355d267b73906c7fd019558f9f85019a9cc0547215e0bcbe3614724572d18149"
    sha256 x86_64_linux:   "dd70e314dbf872a7f0e54bc7364a3c86ed14b8ebe621825512a6421df14f15eb"
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
