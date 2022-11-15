class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2022.09.03.tar.xz"
  mirror "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2022.09.03.tar.xz"
  sha256 "e07454f00d8cae7907bed42d0747798927809947684d94c37207a4d63a32f423"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07da3d145d395749125f2402925fd6995056bf303f9514ed9018cb9140b8d2fd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07da3d145d395749125f2402925fd6995056bf303f9514ed9018cb9140b8d2fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07da3d145d395749125f2402925fd6995056bf303f9514ed9018cb9140b8d2fd"
    sha256 cellar: :any_skip_relocation, ventura:        "e7e7b1edebfa9d71d86a1885139b5271986eaddb691f5a5b826337910595fe68"
    sha256 cellar: :any_skip_relocation, monterey:       "e7e7b1edebfa9d71d86a1885139b5271986eaddb691f5a5b826337910595fe68"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7e7b1edebfa9d71d86a1885139b5271986eaddb691f5a5b826337910595fe68"
    sha256 cellar: :any_skip_relocation, catalina:       "e7e7b1edebfa9d71d86a1885139b5271986eaddb691f5a5b826337910595fe68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8d9592853fb11e37c161cf4eba16e4ba34b1720ac61d016793ca5ab7d34e19"
  end

  # autoconf-archive is useless without autoconf
  depends_on "autoconf"

  conflicts_with "gnome-common", because: "both install ax_check_enable_debug.m4 and ax_code_coverage.m4"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m4").write <<~EOS
      AC_INIT(myconfig, version-0.1)
      AC_MSG_NOTICE([Hello, world.])

      m4_include([#{share}/aclocal/ax_have_select.m4])

      # from https://www.gnu.org/software/autoconf-archive/ax_have_select.html
      AX_HAVE_SELECT(
        [AX_CONFIG_FEATURE_ENABLE(select)],
        [AX_CONFIG_FEATURE_DISABLE(select)])
      AX_CONFIG_FEATURE(
        [select], [This platform supports select(7)],
        [HAVE_SELECT], [This platform supports select(7).])
    EOS

    system "#{Formula["autoconf"].bin}/autoconf", "test.m4"
  end
end
