class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.5.tar.gz"
  mirror "https://sources.lede-project.org/re-0.5.5.tar.gz"
  sha256 "90917a173de962d3b20ab5f9875ad3051b7b307da4acb80c184b72e6c2ba7bb4"

  bottle do
    cellar :any
    sha256 "513b4ceb7dd3c50cebe436fe57eae549e3af5e97f074231b337dac4075d8f40d" => :sierra
    sha256 "948b614c46b7ee5943f93412e46efdcb15497349d61398b1720ee4351b8df4ed" => :el_capitan
    sha256 "cecbe216cbb73cb8f6b0cadf4198eb2f3ad296e0e5ced9acb51c24cd0efc8f71" => :yosemite
  end

  depends_on "openssl"
  depends_on "lzlib"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
