class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.5.2/bzip3-1.5.2.tar.gz"
  sha256 "9d10092a3842378e6d0b16992ee49f711304d88eb4efac80440338184d4b6276"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad8bae59027a6b9d3a3d8aa759c6586a43204e66e23938a51f1ff7f66587b3c7"
    sha256 cellar: :any,                 arm64_sonoma:  "e2380b06a3a38d6a312d8abbf70ade17cd7127c357055756552213d25195709c"
    sha256 cellar: :any,                 arm64_ventura: "d20858e93f7d71dbd465b49c25c29b9bd59c3a572846599df1253ee7e7e1729a"
    sha256 cellar: :any,                 sonoma:        "d2a113243e5510ae45b8080250b844847f1fde3bb1df66373a1cdd658be56cac"
    sha256 cellar: :any,                 ventura:       "4ab6f2e55319729e67acaf179395228ec7cc191f87d2e78886c0753fc1725880"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b63f8228410a4cf5ae10f594eec3f18d5697b1bfa5f70b57254b8944d9eb79d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1703e4aa6739acac3188b2d7f3c5881f9fd2562351ee6752f16af96c2efd82cc"
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
