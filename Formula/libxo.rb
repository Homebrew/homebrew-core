class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/0.9.0/libxo-0.9.0.tar.gz"
  sha256 "81fa2843e9d2695b6308a900e52e67d0489979f42e77dae1a5b0c6a4c584fc63"

  bottle do
    sha256 "16bec82ed1371cbb0831f8804533f3fccdf59621faf236e9cdc48c0057c513a3" => :mojave
    sha256 "f93b9ced03df4919102a7e5f93a243143af9107d5e63479279033d8b443203e3" => :high_sierra
    sha256 "e3c9b12d7b8783a845557f9aba7a00bc5c73308242747307aca38336950c076c" => :sierra
    sha256 "80d3c763c552f4cd268431132f0aa058d8ce98cd010f85fc021a3265ebc01e0d" => :el_capitan
  end

  depends_on "libtool" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end
