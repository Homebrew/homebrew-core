class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://libsodium.org/"
  url "https://download.libsodium.org/libsodium/releases/libsodium-1.0.20.tar.gz"
  sha256 "ebb65ef6ca439333c2bb41a0c1990587288da07f6c7fd07cb3a18cc18d30ce19"
  license "ISC"

  livecheck do
    url "https://download.libsodium.org/libsodium/releases/"
    regex(/href=.*?libsodium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "fc8c1b02d3c050f67d92d6ca76b10b6f4d720a6ec148e1438ae12a5a13a502f0"
    sha256 cellar: :any,                 arm64_sequoia:  "e8ba0aafe8fe7266d68630ff7ab11d7357af35dbf5113bb648a1e02bed397970"
    sha256 cellar: :any,                 arm64_sonoma:   "66835fcd7e4dd8dde5be4e8d34c5314481c1d724e8dd82d4e97059d9fdaf1a45"
    sha256 cellar: :any,                 arm64_ventura:  "21b83b95eef039b914d712f4ac5d235d85e1f1143383dfa9c5359f0cc88fa08d"
    sha256 cellar: :any,                 arm64_monterey: "25377f9e16747b9af732be608a966b580287d0854c2d530f23eea1235bca1ff7"
    sha256 cellar: :any,                 sonoma:         "ebc452002391195287aef3819c1285ba597bbfe55cb926f18dae5990202afa12"
    sha256 cellar: :any,                 ventura:        "5de3b5180b73678d93c4c69a77d662afd6aac0bfd71246be6e78cfacf97cc3d7"
    sha256 cellar: :any,                 monterey:       "0556f27feb8d4b5f31edf42e392eb4901daa5b9dbb8510499aa196c9e77134c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5a31f0fb4b4c1d89161e49a5f94bef970b0f23068475ef3dc46589d869f52a38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94394d217dc5a833492a702a8a9e914573a945da13f3b4f42b59f2513835f439"
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
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <sodium.h>

      int main()
      {
        assert(sodium_init() != -1);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}",
                   "-lsodium", "-o", "test"
    system "./test"
  end
end
