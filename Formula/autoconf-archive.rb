class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2016.09.16.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2016.09.16.tar.xz"
  sha256 "e8f2efd235f842bad2f6938bf4a72240a5e5fcd248e8444335e63beb60fabd82"

  bottle do
    cellar :any_skip_relocation
    sha256 "45734c6b3d192455d2acc3869dbb94ae2bc09a55fb86a348ff62769d71c16cbd" => :sierra
    sha256 "7ae05e07723ff6ac37e0847f1233b7021b0fd25496a4d52a4198fa9ba6b48942" => :el_capitan
    sha256 "c03a8439f143550e2fd7f94ea8053c00a6023f794faadd0ce6a6b0ebe654f225" => :yosemite
    sha256 "c03a8439f143550e2fd7f94ea8053c00a6023f794faadd0ce6a6b0ebe654f225" => :mavericks
  end

  # autoconf-archive is useless without autoconf
  depends_on "autoconf" => :run

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.m4").write <<-EOS.undent
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
