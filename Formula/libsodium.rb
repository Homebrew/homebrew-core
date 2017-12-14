class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.16/libsodium-1.0.16.tar.gz"
  sha256 "eeadc7e1e1bcef09680fb4837d448fbdf57224978f865ac1c16745868fbd0533"

  bottle do
    cellar :any
    sha256 "b2faf056b42788bfbedeee32166c3aa9c3d382f9dadf306100b6ef0d0342a64a" => :high_sierra
    sha256 "decfe8fd1c593c8b202c99a4dc3dc21e25adf39c9cb1e8de792c7801cef66d67" => :sierra
    sha256 "59597f646d332373e951a7b1ff6ebd4b88898016555494f27e5f195a1bed16d2" => :el_capitan
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
    (testpath/"test.c").write <<~EOS
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
