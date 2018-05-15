class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.1.6.tar.xz"
  sha256 "4da0bb9e32cab230e63bf65252076f9a4b5e40eb9ec2ddaf9376bcef30e7bda7"

  bottle do
    cellar :any
    sha256 "320533cd3bde572569e66e8f6fa4f374cd48d5f5bf42308d7f7e730d3d2dfef5" => :high_sierra
    sha256 "9e7ce57ed280b4687f76dd844fbc58743789c9de0aec627ab3317b708119a89b" => :sierra
    sha256 "774a87d585b6bfba1a7df69d0016c62dd2da05866c7cacdf6d8e35509cce6937" => :el_capitan
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
