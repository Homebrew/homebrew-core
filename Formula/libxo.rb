class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/0.9.0/libxo-0.9.0.tar.gz"
  sha256 "81fa2843e9d2695b6308a900e52e67d0489979f42e77dae1a5b0c6a4c584fc63"

  bottle do
    sha256 "dc715f036d728b24c98a451fc7a27802e14dc6132d43e4bc484c3f3d0d3eb277" => :high_sierra
    sha256 "f70c0997985665361bf4a11e274eebcc8038f44fcc527c3f2ad3cc2b8c9f4d61" => :sierra
    sha256 "d6e6bc08ad85bc51405a3d4fdbc6f39fb41e55b46149dbcf93fa5170672a442d" => :el_capitan
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
