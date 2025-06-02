class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.3.6/libtirpc-1.3.6.tar.bz2"
  sha256 "bbd26a8f0df5690a62a47f6aa30f797f3ef8d02560d1bc449a83066b5a1d3508"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "c16ef4d7037e9f47895388ed87cabd6204ec34131e0093267f6526eed8f9ee6c"
    sha256 cellar: :any,                 arm64_sonoma:  "8ee7ac3b3b1df398b032656eccd643b5acc54d7e02959f1615690ecde92116e1"
    sha256 cellar: :any,                 arm64_ventura: "75b9446214bec564b88e7d765cffb241497d1ae41e349fd6f584de3d8cbc5c26"
    sha256 cellar: :any,                 sonoma:        "72e659c72370584a373cc916acafe7a51db67a10ad7c8fbaa9fc311fc49ff790"
    sha256 cellar: :any,                 ventura:       "7a87780cba64ee5fa5e65686d4bcc51236ccf4b33a11c8732d0ad59ad7b003c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "016bd1553348df8e15bc09280a00b40562da46aa875f9741292f129bd0666467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93daf0554770cfcd883a74d9bcbb208702c23b8d90d0c1daa9b040be52b9657c"
  end

  depends_on "krb5"

  def install
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542" if OS.mac?
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <rpc/rpc.h>
      #include <rpc/xdr.h>
      #include <stdio.h>

      int main() {
        XDR xdr;
        char buf[256];
        xdrmem_create(&xdr, buf, sizeof(buf), XDR_ENCODE);
        int i = 42;
        xdr_destroy(&xdr);
        printf("xdr_int succeeded");
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/tirpc", "-ltirpc", "-o", "test"
    system "./test"
  end
end
