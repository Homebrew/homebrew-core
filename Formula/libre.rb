class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.1.tar.gz"
  sha256 "4ae7622490b164a992f80592e326c0091654a887905e1bee152cf247dd7d46e3"

  bottle do
    cellar :any
    sha256 "e901ffd00baa45c1daf73ade5b360dfacb659395c12f1b55ea3ff0fd7c5d76a9" => :sierra
    sha256 "98e5b8829d6ccd6d6714acae45214634ca57eea9b14c49bae1fb6648abaf225c" => :el_capitan
    sha256 "7308dbeefa0dc29231c4b1bfbb918179d825d379ff2cf016742bbf9f29c7ae89" => :yosemite
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
    system ENV.cc, "test.c", "-lre"
  end
end
