class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.11/nagios-plugins-2.4.11.tar.gz"
  sha256 "1a68356c8a0d16f393857eba3256e3928d043a9ae2a4ad839bd4681771fe1c1a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "f3ac96a35cfadb359a36c761360473b38be5eb1e0b380e9dec6cd010c6754bd8"
    sha256 arm64_ventura:  "2ce722c895d2adb57b366a1108a30902140dd201246183da08eb85c098a96aa5"
    sha256 arm64_monterey: "f6f98e78b780159e073ef972ea8eca55390af0d7ab83e84192f0e832798577ba"
    sha256 sonoma:         "056afac9bb73067773d79c3a1f89c692bd3ce5f886ff0eb6a08d31326ec31f46"
    sha256 ventura:        "01ed0bbcf108482acf1a2bab9760c5c0be0ae0c2aff683689f2e081b4cd1e125"
    sha256 monterey:       "42a601afdedad17e58cd57116ef75408b0fccdb7d93e9a2df68ed5c31b1c6243"
    sha256 x86_64_linux:   "e960930eca9094c2cf6a0b23b84114b7a68e714a5fe2dadaedc597023aa21748"
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
