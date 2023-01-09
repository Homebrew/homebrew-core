class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.2.1/bzip3-1.2.1.tar.gz"
  sha256 "bba90d867f53efa4291de1df9c22da1578e1a93ca819e0fc68881da6fcc4149d"
  license "LGPL-3.0-only"

  # Fix -flat_namespace being used on Big Sur and later.
  # upstream patch commit, https://github.com/kspalaiologos/bzip3/commit/e667cacfaa0b4b56e45d48e0496041c376c82d53
  # remove in next release
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-arch-native"
    system "make", "install"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz3"

    testfilepath.write "TEST CONTENT"

    system bin/"bzip3", testfilepath
    system bin/"bunzip3", "-f", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
