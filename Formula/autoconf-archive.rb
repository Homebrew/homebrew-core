class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2021.02.19.tar.xz"
  mirror "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2021.02.19.tar.xz"
  sha256 "e8a6eb9d28ddcba8ffef3fa211653239e9bf239aba6a01a6b7cfc7ceaec69cbd"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7534edb1ee8fc202616422b29a63001f4b126c3af117759d13cf4d84b20ef580"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d26fd3151dd3c363c91ea3c507d3c7dab579b906cf610d37c944abce78cc42a"
    sha256 cellar: :any_skip_relocation, monterey:       "e520c12e6203011dcfd64fbb7119235a1f99cf8a0e8717bd6142d9f005f64b62"
    sha256 cellar: :any_skip_relocation, big_sur:        "c86fcd19fecc5c52847daebba5f81c768eb2d1c3f80cc3f8bee7ef1d0eb6e08c"
    sha256 cellar: :any_skip_relocation, catalina:       "5eebb7b244cba512dc9ebb16d6ec6743d7c3859079af58213027adbdad6807de"
    sha256 cellar: :any_skip_relocation, mojave:         "d2957cc212b85b0627cfb70760d7ab7d18dd984d838f9b62f8267b09220831ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7534edb1ee8fc202616422b29a63001f4b126c3af117759d13cf4d84b20ef580"
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
