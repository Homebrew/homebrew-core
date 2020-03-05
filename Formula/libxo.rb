class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/1.4.0/libxo-1.4.0.tar.gz"
  sha256 "aa842d9374bc0c640d9526abdeb6f1dc75c1a14e892eafd3c9e0ee2e8dfc1c43"

  bottle do
    sha256 "3dffbef9394a617fa8c901c44ce7b31b8843c947762744a8ea1374780d5c1224" => :catalina
    sha256 "9c137a2e9828de98fb201d4d8da74eda20e6a276d90a83d8d1fa3017ba7059d1" => :mojave
    sha256 "59d5d434c2ec21fb06dd22b87780e82a31b6eebfd9db795fafece858bc1e4755" => :high_sierra
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
