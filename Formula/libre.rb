class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.6.1.tar.gz"
  sha256 "cd5bfc79640411803b200c7531e4ba8a230da3806746d3bd2de970da2060fe43"

  bottle do
    cellar :any
    sha256 "0ca7e76631b5f30d72b4bc4248e894d00f05cfb785c98856d82cd5cc13e591f9" => :catalina
    sha256 "5d43d79ef2406e40c858463189ca8a40f0b13ede8a7090b56ba0fd1ef942dabc" => :mojave
    sha256 "32787ca36540a0c7c330560076e25726bcca0f08a7b77014d3837bd9c7ca1840" => :high_sierra
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "make", "SYSROOT=#{MacOS.sdk_path}/usr", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
