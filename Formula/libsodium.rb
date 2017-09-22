class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.14/libsodium-1.0.14.tar.gz"
  sha256 "3cfc84d097fdc891b40d291f2ac2c3f99f71a87e36b20cc755c6fa0e97a77ee7"

  bottle do
    cellar :any
    sha256 "c29cfe0ed468d36bfc21673d1257ff8eee77583d4944c456697cb2b57c56b677" => :high_sierra
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
