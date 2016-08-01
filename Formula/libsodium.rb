class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.11/libsodium-1.0.11.tar.gz"
  sha256 "a14549db3c49f6ae2170cbbf4664bd48ace50681045e8dbea7c8d9fb96f9c765"

  bottle do
    cellar :any
    sha256 "99a1a14dbfa6cb2769a5c52add74cb39d65c263f62adebe94419c6a57f7f9ee9" => :el_capitan
    sha256 "d113f4d59d9cac3de12c19bae21a6cc80a8e9df8079fabe73317e92fad63b257" => :yosemite
    sha256 "ad5ba36b6891a728a1ae72197e3942810e7dbcacfb9bb93bb63dfbeaf04d7eae" => :mavericks
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option :universal

  def install
    ENV.universal_binary if build.universal?

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
