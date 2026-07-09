class Libsodium < Formula
  desc "NaCl networking and cryptography library"
  homepage "https://libsodium.org/"
  url "https://download.libsodium.org/libsodium/releases/libsodium-1.0.22.tar.gz"
  sha256 "adbdd8f16149e81ac6078a03aca6fc03b592b89ef7b5ed83841c086191be3349"
  license "ISC"
  compatibility_version 1

  livecheck do
    url "https://download.libsodium.org/libsodium/releases/"
    regex(/href=.*?libsodium[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "665929906297818edf15955cf4e4faefca7d717271c9fa448291989d2511d266"
    sha256 cellar: :any,                 arm64_sequoia: "b231db8b0f993cb764b57560b69f484efe059ec87e47887505aa2d5872cc5a01"
    sha256 cellar: :any,                 arm64_sonoma:  "92072108ab857b6ac1318afd28e5f1a1c3b34fb3e87f7c26c39a817721e0899b"
    sha256 cellar: :any,                 sonoma:        "366ac240d3c97376401ae84c87d8c13852f42b037b6896b402b22336af3f8e32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e73b320fdc416cedb028595212ff6b47f473a0c6e1d7d0aec84cc679734d87bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "985f3f49a2187467eec50c288bb7d71ecd056cdec615441c1a12d8fa77db678a"
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
