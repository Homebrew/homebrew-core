class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.3.8/libtirpc-1.3.8.tar.bz2"
  sha256 "8839959bfcc7a0f4c609d8e4f53f1c67ae33de23775ec35beb39ff15adf11920"
  license "BSD-3-Clause"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5dc87a12351be4204fc6456aa5fa13a36a9881d750835547727b42e439e70b70"
    sha256 cellar: :any, arm64_tahoe:       "b97951d0d42373be38554cede66e7a4481300117ac2e4e5fd6b2a3843c9d08cc"
    sha256 cellar: :any, arm64_sequoia:     "42a991e6d667c2293fed5e12ccb576e1a38a92ee700052c969f815aa8c660836"
    sha256 cellar: :any, arm64_linux:       "97a1e48cc7a4b04c0c312e43eadb1803be638d51b79aef462da14d91d6fe6306"
    sha256 cellar: :any, x86_64_linux:      "69268084b4a21e3b5eaffe3a1a950bb11597dceec0bd3870710f3c74aaca6792"
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
