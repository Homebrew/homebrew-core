class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "https://git.saurik.com/ldid.git",
      tag:      "v2.1.4",
      revision: "2edb2a9307f1bd3909dadc20e80857c6e40c00c5"
  license "AGPL-3.0-or-later"
  head "https://git.saurik.com/ldid.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "db38fe4c61c5c311ecb18ec102f9dc43425860109045e673d3a3ebb8626f1cb2"
    sha256 cellar: :any, big_sur:       "7a37796f816c64f2f7423411f735bc9a9a309d18fb40346b69770682061fb734"
    sha256 cellar: :any, catalina:      "78249bd4fdaaeef269905c5dde76a2a97470b1a562e6ad6b54dcba0eab7f9d82"
    sha256 cellar: :any, mojave:        "6cf13876ed160a27192924a2cb52bcde777f9d9378a66b18073ee35456665576"
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
