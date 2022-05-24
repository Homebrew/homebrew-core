class Libtirpc < Formula
  desc "Port of Sun's Transport-Independent RPC library to Linux"
  homepage "https://sourceforge.net/projects/libtirpc/"
  url "https://downloads.sourceforge.net/project/libtirpc/libtirpc/1.3.2/libtirpc-1.3.2.tar.bz2"
  sha256 "e24eb88b8ce7db3b7ca6eb80115dd1284abc5ec32a8deccfed2224fc2532b9fd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "9e6a05ec31016e1fe1045e6e4c82d8f337a12bfc90ff6faa4092cf48a4084f68"
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
