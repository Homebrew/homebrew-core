class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.6.tar.gz"
  sha256 "a3119826ad162f898ada734d093f565824a018df395b4517549915b00e2bdf69"

  bottle do
    cellar :any
    sha256 "e6427ed47e8e83bdff737282a5f96b1eea80953c2a6f748b099ced2f2ee641eb" => :high_sierra
    sha256 "99447299f02c582fea6e9593d66be8636c6351374c3ce4c5cd585e7fa07d429d" => :sierra
    sha256 "02d6494fd51206f686031d46ee29af54a6368b386746d550f784517643fac85c" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "make", "install", "PREFIX=#{prefix}"
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
