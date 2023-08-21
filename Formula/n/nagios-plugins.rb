class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.6/nagios-plugins-2.4.6.tar.gz"
  sha256 "47af67196507b2ae2ab03a802b0709bcd5e453ec5bdd419333233b5a8485bcd0"
  license "GPL-3.0-or-later"
  head "https://github.com/nagios-plugins/nagios-plugins.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4960e5eef62e7e2a4c73e8e32e8e5dfbbb5401908d0cc246e5b2acbe5a4c09f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b4e86fef3508d9b66f3e9e4066a0efe28561e37e7219d928f78b61c137153fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed56e24ee68dc2b2b39e95e5f9e7c35e96e544918e47494c11ce7d84397e6410"
    sha256 cellar: :any_skip_relocation, ventura:        "90c1c5053635fd159cf9cbb3af0ed660d35ceef405d7cb567fb3fb7dbdacbeb7"
    sha256 cellar: :any_skip_relocation, monterey:       "aba244fdf215c3416ca4be6d2a98feb8dc0b075deb9cfbaa8f026c225fb23a0f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0b34183485cb432daa81b78d7960b33f7ff0bd2fa067dac84559f494a03d4dd"
    sha256                               x86_64_linux:   "19589d1eb2649621e170e338749b8c8c446a714e99e64d8f50bfc99cd7a3ab22"
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
