class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2018.03.13.tar.xz"
  mirror "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2018.03.13.tar.xz"
  sha256 "6175f90d9fa64c4d939bdbb3e8511ae0ee2134863a2c7bf8d9733819efa6e159"

  bottle do
    cellar :any_skip_relocation
    sha256 "608a8ec40924375525fa4f33280088ea7b4136b2255525da34f7f76fee954c5f" => :mojave
    sha256 "10e2660afcbb3d970cd7cac44ad0ebf84f521ab89fd9de25091e752aa0aa9959" => :high_sierra
    sha256 "10e2660afcbb3d970cd7cac44ad0ebf84f521ab89fd9de25091e752aa0aa9959" => :sierra
    sha256 "10e2660afcbb3d970cd7cac44ad0ebf84f521ab89fd9de25091e752aa0aa9959" => :el_capitan
  end

  # autoconf-archive is useless without autoconf
  depends_on "autoconf"

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
