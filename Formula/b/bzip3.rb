class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.5.1/bzip3-1.5.1.tar.gz"
  sha256 "cc7cacda6d15f24d3fe73fd87b895d5fd2c0f8b6dd0630ae4993aa45c4853c3b"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5ed6053de87b75cf367a19809465721eb59151b9d19d1d233e441f986fba2676"
    sha256 cellar: :any,                 arm64_sonoma:  "7507d4f6cd56a8295fee7b742ef150db6b5adb49231eb0df12a1dbd2ced5f781"
    sha256 cellar: :any,                 arm64_ventura: "6ce0294023fc283a7efe5c4c28b5a1271afd3223b77f15aff990a81ead7c0304"
    sha256 cellar: :any,                 sonoma:        "8fbe537f230758a97cb16e8e2dd00405cf71e53cd9ec3d355a9ebbc560670e17"
    sha256 cellar: :any,                 ventura:       "52ac34b6da028c93f8ab6e07c9c569a86b994d2cc7f5de47bc6a88bb9a52dfe5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31ad18fe3a2701f1bd04fca48ad8690b6049eb33f4cd7b948c06708805828a6b"
  end

  def install
    system "./configure", "--disable-silent-rules", "--disable-arch-native", *std_configure_args
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
