class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2019.01.06.tar.xz"
  mirror "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2019.01.06.tar.xz"
  sha256 "17195c833098da79de5778ee90948f4c5d90ed1a0cf8391b4ab348e2ec511e3f"
  license "GPL-3.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4927fe28a3553eb7b369ae1c8f4c4ae52a8897f2409ca0438c2a334466c89163" => :big_sur
    sha256 "c5adb533acd2e940523d4d49878a64ca53acd120144a448b55627ce6876af06e" => :arm64_big_sur
    sha256 "75309bbf34fa9694b048206e2f79c477e8259c22df8173b43b9ec4294cff0f63" => :catalina
    sha256 "18bec44cb2eb240971a855df50102aa6d5e6eadab4a325b3b562a04057991d0c" => :mojave
    sha256 "ef88538afd7d325b368f15e592a62e087b4bddc66f09e65551cc3597fb3da7a3" => :high_sierra
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
