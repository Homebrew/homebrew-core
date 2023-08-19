class Libmemcached < Formula
  desc "C and C++ client library to the memcached server"
  homepage "https://libmemcached.org/"
  url "https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz"
  sha256 "e22c0bb032fde08f53de9ffbc5a128233041d9f33b5de022c0978a2149885f82"
  license "BSD-3-Clause"
  revision 2

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "0511d48bcc88a6860030c5c6bec5d36818068b43f11d67561f1519ce0dbf6b73"
    sha256 cellar: :any,                 arm64_monterey: "37977639be769bfd5ef97d38f408f57cf84f3607ce881c4d6f2c2d7c70a9b2a4"
    sha256 cellar: :any,                 arm64_big_sur:  "2ec7b12e9181c83bbbd45b62ba2a1a0e2958fe2caaa0d94be1da2319831de3be"
    sha256 cellar: :any,                 ventura:        "2807a08a7c29739bd49450c44ec6f926e7c626b3b2104b1ed160226820a5465b"
    sha256 cellar: :any,                 monterey:       "902c0e16ba5ec76696c3f45888ef0c61b840a10b344149242bec812a7c99ee0d"
    sha256 cellar: :any,                 big_sur:        "c41f0bfdc440d240f8d0653dcc87270bd315571eab6979ff94d3271f863cb0e7"
    sha256 cellar: :any,                 catalina:       "70c6e1e3dd76241e343a4a3b38a62fae5bea6d2e2405739b11473d084f4409a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b551d4cc72d953e3018369057901f77a88b1b633661f5acfedcf6bba37385a8b"
  end

  depends_on "memcached" => :test

  # https://bugs.launchpad.net/libmemcached/+bug/1245562
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/60f3532/libmemcached/1.0.18.patch"
    sha256 "592f10fac729bd2a2b79df26086185d6e08f8667cb40153407c08d4478db89fb"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <string.h>

      #include <libmemcached-1.0/memcached.h>

      int main(int argc, char **argv) {
          char conf[50] = "--SERVER=127.0.0.1:";
          strncat(conf, argv[1], 5);
          memcached_st *memc = memcached(conf, strlen(conf));
          assert(memc != NULL);

          // Add a value.
          const char *key = "key";
          const char *val = "val";
          assert(memcached_add(memc, key, strlen(key), val, strlen(val),
                               (time_t)0, (uint32_t)0) == MEMCACHED_SUCCESS);

          // Fetch and check the added value.
          size_t return_val_len;
          uint32_t return_flags;
          memcached_return_t error;
          char *return_val = memcached_get(memc, key, strlen(key),
                                           &return_val_len, &return_flags, &error);
          assert(return_val != NULL);
          assert(error == MEMCACHED_SUCCESS);
          assert(return_val_len == strlen(val));
          assert(strncmp(return_val, val, return_val_len) == 0);
          assert(return_flags == 0);
          free(return_val);

          memcached_free(memc);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmemcached", "-o", "test"

    memcached = Formula["memcached"].bin/"memcached"
    port = free_port
    io = IO.popen("#{memcached} -l 127.0.0.1 -p #{port}")
    sleep 1
    system "./test", port
    Process.kill "TERM", io.pid
  end
end
