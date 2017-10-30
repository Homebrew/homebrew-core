class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.1.4.tar.xz"
  sha256 "6043ec020d96358a4887a3ff09492c4f9f6b5bccc48dcdd8f28b15b1c6157a6f"

  bottle do
    cellar :any
    sha256 "dce0a79fa4ade39b216ed4bc0d95a2a9522ddc84691fb87b4e1d70f06825ec06" => :high_sierra
    sha256 "10b492fd38f6726b8132115a91a6a907ccf5050b76b2a094ed1142dec66867bb" => :sierra
    sha256 "98647a59f024b315146404fde2a9956e229c043ab34d0f59d3a7986d2c975957" => :el_capitan
    sha256 "904e6eeb43f8a9102019b038eb271104732301e818761ca49fe205ab897c1ea5" => :yosemite
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
