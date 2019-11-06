class Libntlm < Formula
  desc "Implements Microsoft's NTLM authentication"
  homepage "https://www.nongnu.org/libntlm/"
  url "https://www.nongnu.org/libntlm/releases/libntlm-1.5.tar.gz"
  sha256 "53d799f696a93b01fe877ccdef2326ed990c0b9f66e380bceaf7bd9cdcd99bbd"

  bottle do
    cellar :any
    sha256 "109de9f032c189a23549f1cbaab29755f1ebe0df362818115942bc2951e85728" => :catalina
    sha256 "803e9685c885410bcb1c071e565299a5c2a91e6ac8484964753b7d69c1b99a61" => :mojave
    sha256 "634e80fcac334380336bba20cae28ec0edce0032c3b6937cd3cfd600f328b9cc" => :high_sierra
    sha256 "ba295e4252ceb8ea27d1634265fe9c63219ea83317dc43713d48ed8f7f064e3e" => :sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
    pkgshare.install "config.h", "test_ntlm.c", "test.txt", "gl/byteswap.h", "gl/md4.c", "gl/md4.h"
  end

  test do
    cp pkgshare.children, testpath
    system ENV.cc, "test_ntlm.c", "md4.c", "-I#{testpath}", "-L#{lib}", "-lntlm", "-DNTLM_SRCDIR=\"#{testpath}\"", "-o", "test_ntlm"
    system "./test_ntlm"
  end
end
