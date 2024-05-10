class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://libsodium.org/"
  url "https://download.libsodium.org/libsodium/releases/libsodium-1.0.19.tar.gz"
  sha256 "018d79fe0a045cca07331d37bd0cb57b2e838c51bc48fd837a1472e50068bbea"
  license "ISC"

  livecheck do
    url "https://download.libsodium.org/libsodium/releases/"
    regex(/href=.*?libsodium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc3c442e29cd2c031179003f04ee2dea388edc68b0f284d6b938f38e2ca49efc"
    sha256 cellar: :any,                 arm64_ventura:  "182de39b6e91d6966cac1982307baa664cf9d59bf387e77caea7d65bf822456d"
    sha256 cellar: :any,                 arm64_monterey: "2bb039f392d4f01cda78cac11b30bda1a37e8474ba8f583e47ce710403a1f630"
    sha256 cellar: :any,                 sonoma:         "211da6345b583cbae203218545b36ecab03482ec33535663773bf96cb8310b4d"
    sha256 cellar: :any,                 ventura:        "12f53fc591d31ff001358580893befa02707b15c22332eebb33f75f32efda41a"
    sha256 cellar: :any,                 monterey:       "68ce4512d9bf1e061edd2d0c09c809d7d63ca61a904802a0bf60cb935613c484"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8ca1515b870335e26ee78bae614a734ccc1f30f3dbad1514f503ce7d9972d5f"
  end

  head do
    url "https://github.com/jedisct1/libsodium.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh", "-sb" if build.head?
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
