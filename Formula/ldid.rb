class Ldid < Formula
  desc "Lets you manipulate the signature block in a Mach-O binary"
  homepage "https://cydia.saurik.com/info/ldid/"
  url "https://git.saurik.com/ldid.git",
      :tag      => "v2.1.2",
      :revision => "c2f8abf013b22c335f44241a6a552a7767e73419"
  head "https://git.saurik.com/ldid.git"

  bottle do
    cellar :any
    sha256 "ba28d7176a7327d74561b0cc183900ef636039b788ca5294aea2f4c3cabfb1e3" => :catalina
    sha256 "9341d755d86dd76e99e65eac8c68f8a0769754bcd9800549ed9ec0387434369f" => :mojave
    sha256 "3cce5ada2635006f922c17090d391ac024314cdea90ee518fbfd791f6158f4ca" => :high_sierra
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
