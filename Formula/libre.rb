class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.4.16.tar.gz"
  sha256 "bc36fcf37302bfdb964374f2842179f1521d78df79e42e74c4fd102e61fa4b29"

  bottle do
    cellar :any
    sha256 "b83e08f9bda6bdaf135cd3ea44f9f0e8ee49efc25d7a1a7d33a05a75a15e0b1b" => :sierra
    sha256 "b27f86fb350b5ad67b06a9725227a16f8a74f84353ba056fb7e747888107dee3" => :el_capitan
    sha256 "1d2b0f0ccdb818095d4ccd6b0ad8a9896e7e7d9102add4cba35121020f79ed05" => :yosemite
    sha256 "bd919c8fdfd4719987f352cd76b8ca5e624255f0e89d8e7095609e122eee122b" => :mavericks
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
