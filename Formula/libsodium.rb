class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.14/libsodium-1.0.14.tar.gz"
  sha256 "3cfc84d097fdc891b40d291f2ac2c3f99f71a87e36b20cc755c6fa0e97a77ee7"

  bottle do
    cellar :any
    sha256 "d615980c2afffb71dd73914c488b4d824bc3ab0ca5a8eb339c654e6699a9d9b4" => :sierra
    sha256 "f42d3558eae5468f1b5efb90314e63d92571782fbf8325c9445c613ed73ab49e" => :el_capitan
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <sodium.h>

      int main()
      {
        assert(sodium_init() != -1);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lsodium", "-o", "test"
    system "./test"
  end
end
