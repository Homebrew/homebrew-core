class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.15/libsodium-1.0.15.tar.gz"
  sha256 "fb6a9e879a2f674592e4328c5d9f79f082405ee4bb05cb6e679b90afe9e178f4"

  bottle do
    cellar :any
    sha256 "7e02a99821db8757cd659cfd14ccde84e49d72a01c7b0b69b6735fa6d2ea85ea" => :high_sierra
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
