class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.13/libsodium-1.0.13.tar.gz"
  sha256 "9c13accb1a9e59ab3affde0e60ef9a2149ed4d6e8f99c93c7a5b97499ee323fd"

  bottle do
    cellar :any
    sha256 "faff8ef65ff555b8a86b21bb238e3dc844405cdfc3348e0f535d1552775bc542" => :sierra
    sha256 "a83c5f4520650c8cb81b11c26a3003aa7bdebb47c19ae1f7ff1c45b249852256" => :el_capitan
    sha256 "afb37b9e1d093888d2d898999bb59fec9496c5efda7cf7dcecfc680199f64419" => :yosemite
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
