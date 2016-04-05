class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://github.com/jedisct1/libsodium/"
  url "https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz"
  sha256 "71b786a96dd03693672b0ca3eb77f4fb08430df307051c0d45df5353d22bc4be"

  bottle do
    cellar :any
    sha256 "a8452225cfa7f52e6b3e72fd264fc8e70c8c52a76a016bdeb203f32cbe8f8176" => :el_capitan
    sha256 "5bbfb4cf3af4f940697673f41c30a20cbd6a3d9f080c9c8df9d27da3641ce907" => :yosemite
    sha256 "75ee29b32c8d12a5250e6a4f8ac62e5d4906fb2483e6384f5b170161b51178a0" => :mavericks
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
    system ENV.cc, "test.c", "-lsodium", "-o", "test"
    system "./test"
  end
end
