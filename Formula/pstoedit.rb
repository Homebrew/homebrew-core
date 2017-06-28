class Pstoedit < Formula
  desc "Convert PostScript and PDF files to editable vector graphics"
  homepage "http://www.pstoedit.net/"
  url "https://downloads.sourceforge.net/project/pstoedit/pstoedit/3.70/pstoedit-3.70.tar.gz"
  sha256 "06b86113f7847cbcfd4e0623921a8763143bbcaef9f9098e6def650d1ff8138c"
  revision 2

  bottle do
    sha256 "085860d9480d7d9558697d403f6628466a8fdfe52f568f21793568d1c71747f2" => :sierra
    sha256 "ee6634e964c7687c5614c9e4358737154ab6f29d53a104416bdc1509b33e6930" => :el_capitan
    sha256 "6330be58259fcfa74062eb1ebfa5eced31aea86ae5f1ce6b2bf49e2f544b3d73" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "plotutils"
  depends_on "ghostscript"
  depends_on "imagemagick"
  depends_on "xz" if MacOS.version < :mavericks

  # Fix for pstoedit search for plugins, thereby restoring formats that
  # worked in 3.62 but now don't in 3.70, including PIC, DXF, FIG, and
  # many others.
  #
  # This patch has been submitted upstream; see:
  # https://sourceforge.net/p/pstoedit/bugs/19/
  #
  # Taken from:
  # https://build.opensuse.org/package/view_file/openSUSE:Factory/pstoedit/pstoedit-pkglibdir.patch?expand=1
  #
  # This patch changes the behavior of "make install" so that:
  # * If common/plugindir is defined, it checks only that directory.
  # * It swaps the check order: First checks whether PSTOEDITLIBDIR exists. If
  #   it exists, it skips blind attempts to find plugins.
  # As PSTOEDITLIBDIR is always defined by makefile, the blind fallback will
  # be attempted only in obscure environments.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fa1823b/pstoedit/3.70.patch"
    sha256 "9af1bbc9db97f5d5dc92816e5c5fdd5f98904f64d1ab0dd6fcdcde1fd8606ce6"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pstoedit", "-f", "pdf", test_fixtures("test.ps"), "test.pdf"
    assert File.exist?("test.pdf")
  end
end
