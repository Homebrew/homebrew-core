class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.3.3/libtirpc-1.3.3.tar.bz2"
  sha256 "6474e98851d9f6f33871957ddee9714fdcd9d8a5ee9abb5a98d63ea2e60e12f3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "26371c5e683f16a4b2ebf4475150672f76d45e3d43583c942fcb0e916be77dc3"
  end

  depends_on "krb5"
  depends_on :linux

  def install
    system "./configure",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rpc/des_crypt.h>
      #include <stdio.h>
      int main () {
        char key[] = "My8digitkey1234";
        if (sizeof(key) != 16)
          return 1;
        des_setparity(key);
        printf("%lu\\n", sizeof(key));
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}/tirpc", "-ltirpc", "-o", "test"
    system "./test"
  end
end
