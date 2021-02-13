class Ht < Formula
  desc "Viewer/editor/analyzer for executables"
  homepage "https://hte.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/hte/ht-source/ht-2.1.0.tar.bz2"
  sha256 "31f5e8e2ca7f85d40bb18ef518bf1a105a6f602918a0755bc649f3f407b75d70"
  license "GPL-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_big_sur: "405e3628c0af358c0014fa5fe79ddd258f1b9b080ecfc2910c362a2daae77785"
    sha256 cellar: :any, big_sur:       "4f552c6754e25dc6d790015516167222490dbf15f2b490b714b078278d444b3e"
    sha256 cellar: :any, catalina:      "94df31fe5a0bd007170030e65a25242acd467270d9960c42a128fcfbfb43e379"
    sha256 cellar: :any, mojave:        "62adaf2ac899b3e0b3e6fec81de26eec41f38be0316f55b42fb0fe2a829dcbe7"
  end

  depends_on "lzo"

  uses_from_macos "ncurses"

  def install
    # Fix compilation with Xcode 9
    # https://github.com/sebastianbiallas/ht/pull/18
    inreplace "htapp.cc", "(abs(a - b) > 1)", "(abs((int)a - (int)b))"

    chmod 0755, "./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-x11-textmode"
    system "make", "install"
  end

  test do
    assert_match "ht #{version}", shell_output("#{bin}/ht -v")
  end
end
