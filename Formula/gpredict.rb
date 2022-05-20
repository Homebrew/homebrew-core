class Gpredict < Formula
  desc "Real-time satellite tracking/prediction application"
  homepage "http://gpredict.oz9aec.net/"
  url "https://github.com/csete/gpredict/releases/download/v2.2.1/gpredict-2.2.1.tar.bz2"
  sha256 "e759c4bae0b17b202a7c0f8281ff016f819b502780d3e77b46fe8767e7498e43"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_monterey: "f873648c8df2b0e87c6b2c6e7553379ca0e239738a01f83a702788f33ba0dcc9"
    sha256 arm64_big_sur:  "2c367d6266bd0af3583827c588ab864c26043444ad6b6379821c1b93e5093352"
    sha256 monterey:       "650854e63dd2ed7f88d40188575d69f5e83e311ebecfc489c13c472adfd5e947"
    sha256 big_sur:        "eccf4afd811d590ed5c930840933905bd5b1ea9bdf42e32e52cf4926d0c1eb05"
    sha256 catalina:       "99fff9473dcc5eaa0c58cf0b2bf04f4240e1598aada45565e4dbbf050d2ac7dc"
    sha256 mojave:         "952941a2ecdb5f75805888dfd020acce48c4f1b29a9c2e3ec8742d35fcd9c829"
    sha256 high_sierra:    "189249444c490bc7984506a3d041de1d057fff671ff774871f549f6b32efa042"
    sha256 sierra:         "9a0a4b0e63b3b1f84830f508d60ee3fc5b5fd0b9a5731241873168baa88209cf"
    sha256 x86_64_linux:   "e87f34490c8549a80627a714275d1ab1f9b73285ea76f28c91b6f45a360963bc"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gettext"
  depends_on "glib"
  depends_on "goocanvas"
  depends_on "gtk+3"
  depends_on "hamlib"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5" if OS.linux?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "real-time", shell_output("#{bin}/gpredict -h")
  end
end
