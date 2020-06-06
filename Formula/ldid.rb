class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "https://git.saurik.com/ldid.git",
      :tag      => "v2.1.2",
      :revision => "c2f8abf013b22c335f44241a6a552a7767e73419"
  head "https://git.saurik.com/ldid.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f80f2e277b47423d0b346004746e4ffe175ab25d919d1579035c7c518c149aa3" => :catalina
    sha256 "ba39a727e8edd9376e0bef4eeb900d8852f90fa7d1a0b50d754f9007185b7764" => :mojave
    sha256 "1b0d2d4b611a914b8cf688ac3f35eba21490654bc8b7401bf47e9e1be77e0f3f" => :sierra
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
                    "-lcrypto", "-lplist", "-lxml2"
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
