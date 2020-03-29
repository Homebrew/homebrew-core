class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.2.0/ltm-1.2.0.tar.xz"
  sha256 "b7c75eecf680219484055fcedd686064409254ae44bc31a96c5032843c0e18b1"
  revision 1
  head "https://github.com/libtom/libtommath.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "700d1c4dfecd1016215158de7436d02452a149c5882ba3fda1201a72d6c3d5ea" => :catalina
    sha256 "9832ceb97e387a519d6ae9b66bb3a7066c1d112d947667527a5edfcc692e4983" => :mojave
    sha256 "26e39af069485ef58c3517fb765db3a5e8dba0f253aac3d0d5968ff2a35e595b" => :high_sierra
  end

  # Fixes mp_set_double being missing on macOS.
  # This is needed by some dependents in homebrew-core.
  # Note: this patch has been merged upstream but we take a backport
  # from a fork due to file name differences between 1.2.0 and master.
  # Remove with the next version.
  patch do
    url "https://github.com/MoarVM/libtommath/commit/db0d387b808d557bd408a6a253c5bf3a688ef274.patch?full_index=1"
    sha256 "e5eef1762dd3e92125e36034afa72552d77f066eaa19a0fd03cd4f1a656f9ab0"
  end

  def install
    ENV["DESTDIR"] = prefix

    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

    system "make"
    system "make", "test_standalone"
    include.install Dir["tommath*.h"]
    lib.install "libtommath.a"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
