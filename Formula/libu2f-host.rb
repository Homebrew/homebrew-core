class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.1.3.tar.xz"
  sha256 "3e00c1910de64e2c90f20c05bb468b183ffed05e13cb340442d206014752039d"

  bottle do
    cellar :any
    sha256 "6b7ecd51461bc647a2c06ea3f29d02cef4eec1fb265d76f81c701c0992eb741a" => :sierra
    sha256 "7f5b2f3c89f1e9c2d9c22f80ebf903e4885c44d34d5da1800b761a622fe4c806" => :el_capitan
    sha256 "35bcfe1d4c996b0b203cc6cf9a41587eb5dcec62ed0ab78ecafe348b17849c3a" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "hidapi"
  depends_on "json-c"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
