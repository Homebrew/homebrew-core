class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.17/libsodium-1.0.17.tar.gz"
  sha256 "0cc3dae33e642cc187b5ceb467e0ad0e1b51dcba577de1190e9ffa17766ac2b1"

  bottle do
    cellar :any
    sha256 "5c79b450a0416c31c363f1d8ffc6762fe4ac1d76c0a6034f893e6ef215308bba" => :mojave
    sha256 "fbacd0565bf421dd62d5bd24f52e8a4c88555a34e30f12081402527dc2cf3ce4" => :high_sierra
    sha256 "a6659232fac60c32ead2535f4b3ad4af708549de3d7b1c8879a8b873dbe3c1a2" => :sierra
    sha256 "d5b1de65e85053a818114e7970927640080cc9b7ee9f21a001bace9a48da83f7" => :el_capitan
  end

  head do
    url "https://github.com/jedisct1/libsodium.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
