class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2022.02.11.tar.xz"
  mirror "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2022.02.11.tar.xz"
  sha256 "78a61b611e2eeb55a89e0398e0ce387bcaf57fe2dd53c6fe427130f777ad1e8c"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d456417fb685f2b9f8a84a4ad1e2f1e37ff6f8208da706aaf5842a1ea51469"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51d456417fb685f2b9f8a84a4ad1e2f1e37ff6f8208da706aaf5842a1ea51469"
    sha256 cellar: :any_skip_relocation, monterey:       "f3953a023045de5ffaf8d9a9b0821e3935b1e98e0bc34b38ae0f48f14e70a57f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3953a023045de5ffaf8d9a9b0821e3935b1e98e0bc34b38ae0f48f14e70a57f"
    sha256 cellar: :any_skip_relocation, catalina:       "f3953a023045de5ffaf8d9a9b0821e3935b1e98e0bc34b38ae0f48f14e70a57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d456417fb685f2b9f8a84a4ad1e2f1e37ff6f8208da706aaf5842a1ea51469"
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
