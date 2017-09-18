class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.5.tar.gz"
  mirror "https://sources.lede-project.org/re-0.5.5.tar.gz"
  sha256 "90917a173de962d3b20ab5f9875ad3051b7b307da4acb80c184b72e6c2ba7bb4"

  bottle do
    cellar :any
    sha256 "d9bcc67db7a0bc93210044147daf6e8eb59dec5190eb768a60d763501af84f53" => :high_sierra
    sha256 "b9901620a2d61f89b554a248ddf24ce36d1a441824f9c86081be66c8b8c59f94" => :sierra
    sha256 "e56bda662069338fc50a4298b7f157dfbb21d9c222ff452338853a558f4eaf15" => :el_capitan
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
