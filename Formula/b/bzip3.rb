class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.4.0/bzip3-1.4.0.tar.gz"
  sha256 "a7bf2369f1ea0e1f2616686348f3749607abadd957519ee09b6f11da02b1039a"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3aa48aeabf11d9b8c4f5f2a69a224485b3a236262fb0abd576aa3ac5ea206be5"
    sha256 cellar: :any,                 arm64_ventura:  "040e396b19bf880ce14404c425676e2ef0590a3c4551ccf0f2dfaf78d179ad68"
    sha256 cellar: :any,                 arm64_monterey: "242f1910fae6ae7127d0d5c55b47694bba0cfb570edaa5f3a1fd630cde6e569c"
    sha256 cellar: :any,                 sonoma:         "9aa62ffbcd58ab5e4b2a2a1db17feadfee05e97e9d3e994ce92db79e04d9f96a"
    sha256 cellar: :any,                 ventura:        "6abc714830c3f253caf3ae0b554ba49603240aaa378377ffbd760e9a5fd00bb4"
    sha256 cellar: :any,                 monterey:       "4abc89e257d80847233ac4ddf6f09519b106faff66416a18034584a461e086d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c98aa7bd0954fff98620d6ee0897df8caccac0f35c22a3d25cff8e9766f086a"
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
