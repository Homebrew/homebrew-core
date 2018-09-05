class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.1.6.tar.xz"
  sha256 "4da0bb9e32cab230e63bf65252076f9a4b5e40eb9ec2ddaf9376bcef30e7bda7"

  bottle do
    cellar :any
    sha256 "35901ea7122dc9fa0eca2c95b2c368932b9f1a2ee25f6432035a45c4f299aeec" => :mojave
    sha256 "1c8bf3998672c1067e4bbd2a17de18e8634b78a2ddd9ab8899c9f1af6e8b44fe" => :high_sierra
    sha256 "563bb00b2ffae07102b045c388033b6e1eb452efb206c208976299da3ce30446" => :sierra
    sha256 "964fa246d7a086ba9bca40c062e6c4e27fd2dc8251d419ff69a4d646cc54498a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "hidapi"
  depends_on "json-c"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <u2f-host.h>
      int main()
      {
        u2fh_devs *devs;
        u2fh_global_init (0);
        u2fh_devs_init (&devs);
        u2fh_devs_discover (devs, NULL);
        u2fh_devs_done (devs);
        u2fh_global_done ();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}/u2f-host", "-L#{lib}", "-lu2f-host"
    system "./test"
  end
end
