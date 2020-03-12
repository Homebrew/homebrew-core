class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.2.0/ltm-1.2.0.tar.xz"
  sha256 "b7c75eecf680219484055fcedd686064409254ae44bc31a96c5032843c0e18b1"
  revision 1
  head "https://github.com/libtom/libtommath.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "74f8fc0290933dde4d0d8c804707bc4dc421c9f88b09c91f8acb140aafd225a8" => :catalina
    sha256 "e827065d024c0699ca3672e1d806377833d46a7fde999666b097cfb7a31c625a" => :mojave
    sha256 "9affad0e48cc7801adcd196813c5d1271fcb2ba94a50169fa633d4ec7804eb2d" => :high_sierra
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
