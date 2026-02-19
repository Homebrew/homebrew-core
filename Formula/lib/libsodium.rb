class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://libsodium.org/"
  url "https://download.libsodium.org/libsodium/releases/libsodium-1.0.21.tar.gz"
  sha256 "9e4285c7a419e82dedb0be63a72eea357d6943bc3e28e6735bf600dd4883feaf"
  license "ISC"

  livecheck do
    url "https://download.libsodium.org/libsodium/releases/"
    regex(/href=.*?libsodium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f67601f25a55e3845e1792c60a7bfab15dd3541fbb03e116b147e252fb153c9a"
    sha256 cellar: :any,                 arm64_sequoia: "e8b956a02a7563e3d2c653de81a7976a8798dc63ba906e65cc2e9f3dff89cb37"
    sha256 cellar: :any,                 arm64_sonoma:  "258e5d00e53f7809780498b615216e20a4a4876f9b96f788e9af56eb4ed3b1be"
    sha256 cellar: :any,                 sonoma:        "437e033a04914c6ce7c3f642410bc924e5c2edfeab136dbd77e0a4d455387bd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef2ff41f468c1eb03d919ee31a903a242e762b1a9bb22f52e34438a907d6bbd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "082cbc3178f73ab138d65735f2b4e8c2d47df2b411f398669482d51c7001d369"
  end

  head do
    url "https://github.com/jedisct1/libsodium.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Allow type conversion between vectors on Arm Linux
    ENV.append_to_cflags "-flax-vector-conversions" if OS.linux? && Hardware::CPU.arm?

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
