class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2023.02.20.tar.xz"
  mirror "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2023.02.20.tar.xz"
  sha256 "71d4048479ae28f1f5794619c3d72df9c01df49b1c628ef85fde37596dc31a33"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ad375a956bd246edd6a9f6a08118572a33d2c0c4732e56343eb557e81ef9e762"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ea643bc91c9234ccfe254e4a510ef3da869c6a7497203b01a94c1c984b25dccc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eff12d495e12588faaececedf65651baef736dd31af94bb3025998a2dcc35ee4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eff12d495e12588faaececedf65651baef736dd31af94bb3025998a2dcc35ee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eff12d495e12588faaececedf65651baef736dd31af94bb3025998a2dcc35ee4"
    sha256 cellar: :any_skip_relocation, sonoma:         "57d43fd96d81578fe46bc6ddcfe4c0d79be9e50d7704b7ad0a2509ee5b5f95cd"
    sha256 cellar: :any_skip_relocation, ventura:        "241f7af27fa98b3cde170df669f5041e1af971fb4846890269d01df8ab26e74b"
    sha256 cellar: :any_skip_relocation, monterey:       "241f7af27fa98b3cde170df669f5041e1af971fb4846890269d01df8ab26e74b"
    sha256 cellar: :any_skip_relocation, big_sur:        "241f7af27fa98b3cde170df669f5041e1af971fb4846890269d01df8ab26e74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270f3e443b7e742f7cd0c6e2c1882d1f6d2912008549a9f8166ea4c0a501b7e2"
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
