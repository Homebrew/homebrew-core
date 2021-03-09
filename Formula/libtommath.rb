class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.2.0/ltm-1.2.0.tar.xz"
  sha256 "b7c75eecf680219484055fcedd686064409254ae44bc31a96c5032843c0e18b1"
  license "Unlicense"
  revision 2
  head "https://github.com/libtom/libtommath.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "8de5c86d359cd3e99ffa9ebd0648d7c255c7b6e63f3298af76863c99bd6e4660"
    sha256 cellar: :any, big_sur:       "926fe5c304e1bc15bc32c94fcf11728a98ef6d64c46ea7544dba60ce9aacd1c3"
    sha256 cellar: :any, catalina:      "16562795b0510326aecc42646ddd1b0dcc212dccb7307eec15fb1d17236085f1"
    sha256 cellar: :any, mojave:        "5b7fb5610176a90288ea0b6d97e8279a401dd4c627e85a66b623a5f971f3902a"
  end

  depends_on "libtool" => :build

  # Fixes mp_set_double being missing on macOS.
  # This is needed by some dependents in homebrew-core.
  # NOTE: This patch has been merged upstream but we take a backport
  # from a fork due to file name differences between 1.2.0 and master.
  # Remove with the next version.
  patch do
    url "https://github.com/MoarVM/libtommath/commit/db0d387b808d557bd408a6a253c5bf3a688ef274.patch?full_index=1"
    sha256 "e5eef1762dd3e92125e36034afa72552d77f066eaa19a0fd03cd4f1a656f9ab0"
  end

  def install
    ENV["DESTDIR"] = prefix

    system "make", "-f", "makefile.shared", "install"
    system "make", "test"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
