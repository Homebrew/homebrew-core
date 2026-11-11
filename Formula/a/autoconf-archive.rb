class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftpmirror.gnu.org/autoconf-archive/autoconf-archive-2026.11.11.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2026.11.11.tar.xz"
  sha256 "2c18f15e2b3bb79e09622b27391df07d8608ce9f07fbfc7c1143fa683891ab26"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4e3dde48154731d2cd0a8d76c296b96f78927e8fc2d41d67bdd29d100eaf08f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "75991b9174b35f768e55c113e3cca5f1b88939590ea865b4072426230fdef4ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7652c1e3d7ef6dc9cc8d6ef298f1bfe80d9888876052bedba5f5638b5e280945"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "7652c1e3d7ef6dc9cc8d6ef298f1bfe80d9888876052bedba5f5638b5e280945"
    sha256 cellar: :any_skip_relocation, arm64_ventura:     "7652c1e3d7ef6dc9cc8d6ef298f1bfe80d9888876052bedba5f5638b5e280945"
    sha256 cellar: :any_skip_relocation, sonoma:            "ffb73dbda72f41e7b21402df83c9b72f2570e37a8cdad47d0a90768aa5b5d2a3"
    sha256 cellar: :any_skip_relocation, ventura:           "ffb73dbda72f41e7b21402df83c9b72f2570e37a8cdad47d0a90768aa5b5d2a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8185cedad20ff9606d383493e300a38f608a408b677490b7192ad698b3b02ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1ce036c58366f08d63911e57d2bf5db88d008ac6fce194f8e8a41a073e92a1a8"
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
