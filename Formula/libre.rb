class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "http://www.creytiv.com"
  url "http://www.creytiv.com/pub/re-0.5.1.tar.gz"
  sha256 "4ae7622490b164a992f80592e326c0091654a887905e1bee152cf247dd7d46e3"

  bottle do
    cellar :any
    sha256 "fdb943ecd678e49f4fcb9d6859bd136d0f7adfd9cf4846bb117af22a9faf908f" => :sierra
    sha256 "c8b8ac2b582cd31a22fb1bb94c4b105e2a5cfe0db8b37958750f30cf7ddc878f" => :el_capitan
    sha256 "b7b223f2d9cfce1cb1037dd7ebc37b79915c62e474f0c67238ad6114a0d311a2" => :yosemite
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
