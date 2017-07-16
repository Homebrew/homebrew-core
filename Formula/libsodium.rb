class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.13/libsodium-1.0.13.tar.gz"
  sha256 "9c13accb1a9e59ab3affde0e60ef9a2149ed4d6e8f99c93c7a5b97499ee323fd"

  bottle do
    cellar :any
    sha256 "0a64df6bdd78eea1d141776def103b89ef7dad897e0785c14809ba130ad4c22c" => :sierra
    sha256 "53f03968c131fd2c4a2fbbe875287797f5fa4b697922f1a98b8178dc91e40d70" => :el_capitan
    sha256 "b7bae3e647ebf21787d1ad7faa734a41e9d4e1e29aa1e658edf488134e5d60e8" => :yosemite
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
