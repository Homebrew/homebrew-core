class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "https://git.saurik.com/ldid.git",
      tag:      "v2.1.4",
      revision: "2edb2a9307f1bd3909dadc20e80857c6e40c00c5"
  license "AGPL-3.0-or-later"
  head "https://git.saurik.com/ldid.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "429a183d6d31024971e5df4b36dcada47d2ac7e57006bcce8b20ea191c7e8c01"
    sha256 cellar: :any, big_sur:       "15505f156e2d6f768119b849b8b1db1c374eb2f882abde35589c77aef6114f39"
    sha256 cellar: :any, catalina:      "70d4f9704e7e4338eb63c0c8033954fdd7630bfd46d589c47a97167572e009ea"
    sha256 cellar: :any, mojave:        "53f3d9fad6a5ba4f440fed19b6402742d3a01a68bb3370751704663ae7d55101"
  end

  depends_on "libplist"
  depends_on "openssl@1.1"

  def install
    system ENV.cc, "-c",
                   "-o", "lookup2.o", "lookup2.c",
                   "-I."
    system ENV.cxx, "-std=c++11",
                    "-o", "ldid", "lookup2.o", "ldid.cpp",
                    "-I.",
                    "-framework", "CoreFoundation",
                    "-framework", "Security",
                    "-lcrypto", "-lplist-2.0", "-lxml2"
    bin.install "ldid"
    ln_s bin/"ldid", bin/"ldid2"
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main(int argc, char **argv) { return 0; }
    EOS

    system ENV.cc, "test.c", "-o", "test"
    system bin/"ldid", "-S", "test"
  end
end
