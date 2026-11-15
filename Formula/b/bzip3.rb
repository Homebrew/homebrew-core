class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/iczelia/bzip3"
  url "https://github.com/iczelia/bzip3/releases/download/1.5.5/bzip3-1.5.5.tar.gz"
  sha256 "dc3bd8237178e1a2b99d8dcf1f4aeb3593c723788a9863606e121b40784e596d"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1146acb73885c6b8640bf7517221e34fda1b796327c60724ca69d282e63873ba"
    sha256 cellar: :any, arm64_tahoe:       "3c44d92972b3d067382d423b1aef224ad0160a3dc6e0d3330d4b486aa3fd5e2e"
    sha256 cellar: :any, arm64_sequoia:     "f2cfb9f2f5765127c50e9d47cf8fc9898e0782307d1610e04306ba1e161daabc"
    sha256 cellar: :any, arm64_linux:       "65fca08bdd45e54ac956674290d1de88c9c365e84f1b8785ae4a8a4fcc1f35b4"
    sha256 cellar: :any, x86_64_linux:      "25701f2f41e90d41121860142053769415ea3b8a088406e975a33de95eec8b0f"
  end

  depends_on "pkgconf" => :build

  deny_network_access!

  def install
    system "./configure", "--disable-silent-rules", "--disable-arch-native", *std_configure_args
    system "make", "install"
  end

  test do
    testfilepath = testpath/"sample_in.txt"
    zipfilepath = testpath/"sample_in.txt.bz3"

    testfilepath.write "TEST CONTENT"

    system bin/"bzip3", testfilepath
    system bin/"bunzip3", "-f", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
