class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "https://git.saurik.com/ldid.git",
      tag:      "v2.1.2",
      revision: "c2f8abf013b22c335f44241a6a552a7767e73419"
  license "AGPL-3.0"
  revision 1
  head "https://git.saurik.com/ldid.git"

  bottle do
    cellar :any
    sha256 "51d2565a2994575aeee0f3b9e9a2d16ecf58f6159cad2b890896a761946f0499" => :big_sur
    sha256 "5ca1576c3de007da8135ffcab00306a0a67c223261bdf22c9c2d867b71b817f9" => :arm64_big_sur
    sha256 "fdd2c5d784f91bcbe6117d16763c3b552f08c8aa1783cb0d7017fb1832f353d3" => :catalina
    sha256 "b76050d24afe9f92eb6a7f53233c27a530ae59454f7193ff82bcade593022645" => :mojave
    sha256 "2a0dd3dd8e0b34980260054420212932e4010eea4e4245307919527aaca7df58" => :high_sierra
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
