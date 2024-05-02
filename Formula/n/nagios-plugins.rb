class NagiosPlugins < Formula
  desc "Plugins for the nagios network monitoring system"
  homepage "https://www.nagios-plugins.org/"
  url "https://github.com/nagios-plugins/nagios-plugins/releases/download/release-2.4.10/nagios-plugins-2.4.10.tar.gz"
  sha256 "e43d4a655141aa66132f92fe03dfc97db9dfb4173c4c845f1af9574001117a25"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "5ce85db57c3dc0923a8789a256a0988860fa9ee901c61dac689f59954154f2dc"
    sha256 arm64_ventura:  "9270fab5981c85fa19946b9b00dc1272436f15bb3e259216f2910d32c5e53679"
    sha256 arm64_monterey: "99d0a352e1a7d585381eb38dc0424046139aba10e4b131e84d33123a262706e3"
    sha256 sonoma:         "fd24f5c08a4ce32614badb99cfba011597d15fb72fbce798d53e9f1817f2e44c"
    sha256 ventura:        "dd7e8b9882904a5970825de52f43c6f5103226a697a962fb2a2d93b6b386b8d2"
    sha256 monterey:       "878ce6885758aba7703c79092721a46e91108a0391a4d979165599f6a4f937d5"
    sha256 x86_64_linux:   "2d4c2f1929db65b411c24801fcb9b0935c99191521d631ac30fefbc0c961d369"
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
