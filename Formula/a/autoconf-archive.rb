class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2026.11.11.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2026.11.11.tar.xz"
  sha256 "2c18f15e2b3bb79e09622b27391df07d8608ce9f07fbfc7c1143fa683891ab26"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6624b5bf9ac866d076970f7c651e696e8b10759261f8d8517d00ac6cdcbc16c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e6624b5bf9ac866d076970f7c651e696e8b10759261f8d8517d00ac6cdcbc16c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6624b5bf9ac866d076970f7c651e696e8b10759261f8d8517d00ac6cdcbc16c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2f05757b108159913c23ede7c6878675cad8c3bb5933b6ab5bdcdd54556be9da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2f05757b108159913c23ede7c6878675cad8c3bb5933b6ab5bdcdd54556be9da"
  end

  # autoconf-archive is useless without autoconf
  depends_on "autoconf"

  deny_network_access!

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"configure.ac").write <<~M4
      AC_INIT([test], [0.1])
      AX_CHECK_ENABLE_DEBUG
      AC_OUTPUT
    M4

    system formula_opt_bin("autoconf")/"autoconf", "configure.ac"
    assert_path_exists testpath/"autom4te.cache"
  end
end
