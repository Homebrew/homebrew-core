class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/2.4.8/nagios-plugins-2.4.8.tar.gz"
  sha256 "8e09e9ec1676ecead7e7c7d41d5ea48d5c4bfdfaddfc756d0dd732df7c8f85e4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "99683106836b01e6f8a6758abb18a043362be953dcc3c47bb5e02e68bf7e44c1"
    sha256 arm64_ventura:  "0574d3fef8cc0be39cc6896342fdbbcc2a4f1cacd9a5ad928f6e44f513fd5b8c"
    sha256 arm64_monterey: "7bfd35199b9f7b078808fc13d783da5f6316c266a910f9f3d2cdba97ea052382"
    sha256 sonoma:         "2d4cc7864117e3f0009061930c43dd9e690908ae68c0460e632ff398b3d14a54"
    sha256 ventura:        "c955af9605a814902565929d784b80d40178be23bfd441c438531dd3db17ef3a"
    sha256 monterey:       "b40f9476d5618f2db3066de6e72c88f09f62df9076e18dd2b9b8b529a6e8192e"
    sha256 x86_64_linux:   "91f503d22017211fed9cfb022b186e06facb4ce979cd7e92358fab4c9e4a2b96"
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
