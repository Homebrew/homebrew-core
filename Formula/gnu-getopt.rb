class GnuGetopt < Formula
  desc "Command-line option parsing utility"
  homepage "https://github.com/karelzak/util-linux"
  url "https://www.kernel.org/pub/linux/utils/util-linux/v2.37/util-linux-2.37.4.tar.xz"
  sha256 "634e6916ad913366c3536b6468e7844769549b99a7b2bf80314de78ab5655b83"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2cfca1954d025f4ae98d1ad3e88072d97fdb154222ca34dfbfbfd70faebc17df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "955c4c395e0652d5b124a76c333d1eb1656d04ecc1fa1f621c00854264a5681e"
    sha256 cellar: :any_skip_relocation, monterey:       "835d08df086515c0ed35a8017a6ff197c277bd530beb6e4d5a809ffcafb5b736"
    sha256 cellar: :any_skip_relocation, big_sur:        "539510d4ae396e51b7da2aba0a1a4eb99422b16046383ad262e7294ae08b5b65"
    sha256 cellar: :any_skip_relocation, catalina:       "172481cea692d4f962cb964fdf77dee1ef45a62e977392db4aaa91330364c5cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccaff552650b2faca1a8803d55e0d712392f57767b2c55707e996e5c77fbca9a"
  end

  keg_only :provided_by_macos

  depends_on "asciidoctor" => :build

  on_linux do
    keg_only "conflicts with util-linux"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "getopt", "misc-utils/getopt.1"

    bin.install "getopt"
    man1.install "misc-utils/getopt.1"
    bash_completion.install "bash-completion/getopt"
  end

  test do
    system "#{bin}/getopt", "-o", "--test"
  end
end
