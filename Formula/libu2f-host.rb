class Libu2fHost < Formula
  desc "Host-side of the Universal 2nd Factor (U2F) protocol"
  homepage "https://developers.yubico.com/libu2f-host/"
  url "https://developers.yubico.com/libu2f-host/Releases/libu2f-host-1.1.3.tar.xz"
  sha256 "3e00c1910de64e2c90f20c05bb468b183ffed05e13cb340442d206014752039d"

  bottle do
    cellar :any
    sha256 "518360dca7f96c4a05a8b677dc03196b4a513386456a001970d5e292ddc95f95" => :sierra
    sha256 "33457975094b80d0ac9e9cf60eccdeb5e2170a9eba4c674eb407790c47cc18b4" => :el_capitan
    sha256 "e8cc07fa0e0b54804e92e49cb077d4eb0f95eb449abd4364c1acf90a94b609ce" => :yosemite
    sha256 "5c3c790e88e08cabe8ab23d0e32765e961ada219c3c5185d6d7d2bd0c10c3a85" => :mavericks
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
