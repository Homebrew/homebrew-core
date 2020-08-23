class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.1.10.tar.xz"
  sha256 "4265789ec59555a1f383ea2d75da085f78ee4cf1cd7c44a2b38662de02dd316f"
  license "GPL-3.0"
  revision 1

  bottle do
    cellar :any
    sha256 "461c37c919d585c8abca2fbff636332c27462cc8f10c04d5762e357c453f7066" => :catalina
    sha256 "deed9f64b0e078130c5618ce98580b9b1b284c531cfb04e6296a8d5b259b6a81" => :mojave
    sha256 "376aa8fc3a98d4aab29ba7d284a58bf07308fda51aa30da72e068f8a6206505e" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "hidapi"
  depends_on "json-c"

  # Compatibility with json-c 0.14. Remove with the next release.
  patch do
    url "https://github.com/Yubico/libu2f-host/commit/840f01135d2892f45e71b9e90405de587991bd03.patch?full_index=1"
    sha256 "6752463ca79fb312d4524f39d2ac02707ef6c182450d631e35f02bb49565c651"
  end

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
