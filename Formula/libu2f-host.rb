class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.1.10.tar.xz"
  sha256 "4265789ec59555a1f383ea2d75da085f78ee4cf1cd7c44a2b38662de02dd316f"

  bottle do
    cellar :any
    sha256 "f5f81e919cec26ad9aeb7fb72c1b3787e83622815ec6f5d1a7a96a3a8af248cb" => :catalina
    sha256 "de1df148c237465d9211d31f885845c44332a797b577f96d231461e822da8194" => :mojave
    sha256 "29ed5c81b0310b148b65e377d5197311edbada65dfe84d6ab193b701fd982af4" => :high_sierra
    sha256 "5ee537e748bb3c59aa28c640c656acb25680d37c34933684453a256921ab3f51" => :sierra
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
