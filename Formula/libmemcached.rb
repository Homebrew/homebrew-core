class Libmemcached < Formula
  desc "C and C++ client library to the memcached server"
  homepage "https://libmemcached.org/"
  url "https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz"
  sha256 "e22c0bb032fde08f53de9ffbc5a128233041d9f33b5de022c0978a2149885f82"
  revision 2

  bottle do
    cellar :any
    sha256 "0c7902542fe3b047ce0a512296b1ec3e0da3d731fef0cbd5143152ce17d8f778" => :mojave
    sha256 "351ec4bceab1983a0523739f241c7b3dfb5c9c4c98fe04ae89533de71e0d462b" => :high_sierra
    sha256 "f0fc1410caf2e9bfa130c52758a3d3a98a34032fe3d37a20980ab219042b6487" => :sierra
    sha256 "7b2540dda66e3de1be0603aafa10a18a006768f698a7db289c380235dad109a3" => :el_capitan
    sha256 "4e7e0cfb8f4d8f31e36c23b545ad3b0153c2f6d99645abf603f7e9f1ed427296" => :yosemite
  end

  depends_on "memcached"

  # https://bugs.launchpad.net/libmemcached/+bug/1245562
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/60f3532/libmemcached/1.0.18.patch"
    sha256 "592f10fac729bd2a2b79df26086185d6e08f8667cb40153407c08d4478db89fb"
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
          const char *conf = "--SERVER=localhost:11211";
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
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lmemcached", "test.c", "-o", "test"

    memcached = Formula["memcached"].bin/"memcached"
    # Assumes port 11211 is not already taken
    io = IO.popen("#{memcached} --listen=localhost:11211")
    sleep 1
    system "./test"
    Process.kill "TERM", io.pid
  end
end
