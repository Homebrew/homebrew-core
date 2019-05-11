class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.6.0.tar.gz"
  sha256 "0e97bcb5cc8f84d6920aa78de24c7d4bf271c5ddefbb650848e0db50afe98131"

  bottle do
    cellar :any
    sha256 "9bf43c79274a095e15b6a4f726c9750c2972b48900581b98c79cef773b929a0d" => :mojave
    sha256 "8194eefcf23d4c37a7d30f9a15b47d576f6a2506078c2cfe99bf690ce78b6bdd" => :high_sierra
    sha256 "224690c1ce6b7912c997b5d454c308cd9be3d231d5e7b1763f3274b2eeaba719" => :sierra
    sha256 "ca45de9ec5798c63537e0492daf15c0c52774961aaf2d2bc38fc3e3a0913f059" => :el_capitan
  end

  depends_on "openssl"

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
