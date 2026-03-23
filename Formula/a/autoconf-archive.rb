class AutoconfArchive < Formula
  desc "Collection of over 500 reusable autoconf macros"
  homepage "https://savannah.gnu.org/projects/autoconf-archive/"
  url "https://ftpmirror.gnu.org/gnu/autoconf-archive/autoconf-archive-2024.10.16.tar.xz"
  mirror "https://ftp.gnu.org/gnu/autoconf-archive/autoconf-archive-2024.10.16.tar.xz"
  sha256 "7bcd5d001916f3a50ed7436f4f700e3d2b1bade3ed803219c592d62502a57363"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75991b9174b35f768e55c113e3cca5f1b88939590ea865b4072426230fdef4ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7652c1e3d7ef6dc9cc8d6ef298f1bfe80d9888876052bedba5f5638b5e280945"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7652c1e3d7ef6dc9cc8d6ef298f1bfe80d9888876052bedba5f5638b5e280945"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7652c1e3d7ef6dc9cc8d6ef298f1bfe80d9888876052bedba5f5638b5e280945"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffb73dbda72f41e7b21402df83c9b72f2570e37a8cdad47d0a90768aa5b5d2a3"
    sha256 cellar: :any_skip_relocation, ventura:       "ffb73dbda72f41e7b21402df83c9b72f2570e37a8cdad47d0a90768aa5b5d2a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8185cedad20ff9606d383493e300a38f608a408b677490b7192ad698b3b02ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ce036c58366f08d63911e57d2bf5db88d008ac6fce194f8e8a41a073e92a1a8"
  end

  # autoconf-archive is useless without autoconf
  depends_on "autoconf"

  # Fix quoting of `m4_fatal`
  # https://github.com/autoconf-archive/autoconf-archive/pull/312
  # https://github.com/Homebrew/homebrew-core/issues/202234
  patch do
    url "https://github.com/autoconf-archive/autoconf-archive/commit/fadde164479a926d6b56dd693ded2a4c36ed89f0.patch?full_index=1"
    sha256 "4d9a4ca1fc9dc9e28a765ebbd1fa0e1080b6c8401e048b28bb16b9735ff7bf77"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"configure.ac").write <<~EOS
      AC_INIT([test], [0.1])
      AX_CHECK_ENABLE_DEBUG
      AC_OUTPUT
    EOS

    system Formula["autoconf"].bin/"autoconf", "configure.ac"
    assert_path_exists testpath/"autom4te.cache"
  end
end
