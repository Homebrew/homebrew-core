class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.1.5.tar.xz"
  sha256 "f32b71435edf6e412f2971edef411f3b4edb419a5356553ad57811ece4a63a95"

  bottle do
    cellar :any
    sha256 "35386868f78aa7140d1c9ed454fca428b029d837c43d8305613665cf950b3ca7" => :high_sierra
    sha256 "ae857c0f76b7c8ed45a84f83e103aac2ca8831ab1d079e66ec9d00cb64970687" => :sierra
    sha256 "3ad0d4837be1a01dcf8f1b529320ceeffe29dfd91c63a9e2e90baa7cfeaccc7f" => :el_capitan
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
