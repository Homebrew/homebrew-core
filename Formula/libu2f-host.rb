class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.1.10.tar.xz"
  sha256 "4265789ec59555a1f383ea2d75da085f78ee4cf1cd7c44a2b38662de02dd316f"

  bottle do
    cellar :any
    sha256 "d33c41a856bcbdb1bd10b8c33bfe3e2066ca8aa488ccd6e6d62a237cf1f56a90" => :mojave
    sha256 "7e2a76534a120e51729bd5587825f3d586fcad4ffa26c71c800cb3d959734389" => :high_sierra
    sha256 "86d8f610d34ba53dba98377fd5b7550082e340ee94b2ca4e25d0d662ed64136b" => :sierra
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
