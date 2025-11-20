class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.3.7/libtirpc-1.3.7.tar.bz2"
  sha256 "b47d3ac19d3549e54a05d0019a6c400674da716123858cfdb6d3bdd70a66c702"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2cf5d4f383c13b44931d5d608d807a0f3c7f2d00e93021267b40326ebc4669c7"
    sha256 cellar: :any,                 arm64_sequoia: "8f7acea1ebea5151f3e7b1ca7a208d2d1a78493eab4ec9052ee8ba3dabbe0c3d"
    sha256 cellar: :any,                 arm64_sonoma:  "ca87dd692fd613265773dd1b70d57b5cf4e0c2cda4f2f85bd6877e740e65b996"
    sha256 cellar: :any,                 arm64_ventura: "08e618a8ff33a2f22dde28337c945047bb43780bd3384e908e60a4a08e20c5f3"
    sha256 cellar: :any,                 sonoma:        "96fca5f15034ecaac893ebd5b9afd0c8504e76bdde0f985232a3a83add4aec7e"
    sha256 cellar: :any,                 ventura:       "a2050dc9f4087267e119bb87b1568e9880115bc9b2148fd7aed0d210574c2a5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6db16084804a4d201c2e3154bc09b707a6f7a3b216f2829e18d21ebf90fe783a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdf824eba64ba33fe3f47809be7c1e62e3795ff20f62b1329e5fad45071cd934"
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
