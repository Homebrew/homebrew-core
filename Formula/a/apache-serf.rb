class ApacheSerf < Formula
  desc "High-performance asynchronous HTTP client library"
  homepage "https://serf.apache.org/"
  license "Apache-2.0"
  head "https://github.com/apache/serf.git", branch: "trunk"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=serf/serf-1.3.10.tar.bz2"
    mirror "https://archive.apache.org/dist/serf/serf-1.3.10.tar.bz2"
    sha256 "be81ef08baa2516ecda76a77adf7def7bc3227eeb578b9a33b45f7b41dc064e6"

    # Backport commit to use non-system zlib
    patch do
      url "https://github.com/apache/serf/commit/15ca053c4bfb00ad4d262686e1a30b5795b6ab81.patch?full_index=1"
      sha256 "d2ab43081a2fc60c6d00df1afc6946895921c91d09cac05a186f820282bea9c6"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cafe248c972f4b6f4ed05745e4e4a9950a7469e6216b27b6cb6f29c99ecdf0bd"
    sha256 cellar: :any, arm64_sequoia: "f5d4fc56a03390c1689d731f7e73eecd41215d4a884cebe73afbdd74723810c1"
    sha256 cellar: :any, arm64_sonoma:  "9eae42200cb24ed6dad84b19a8394d9cb1aa5d1d65ccdffd919c432b47f07dbe"
    sha256 cellar: :any, sonoma:        "eba08705a3beea2a24b1ef71f67269d0890a611fe066131b8c48b88759592489"
    sha256               arm64_linux:   "4265ddae6471dda76a024ad50592a4871c52594e8f8e215b1f28201b22465b39"
    sha256               x86_64_linux:  "0bf90799a933a7d5aa306b5263bdf96e842375bb2fb777363399ed351c24ee19"
  end

  depends_on "scons" => :build
  depends_on "pkgconf" => :test
  depends_on "apr"
  depends_on "apr-util"
  depends_on "openssl@3"

  uses_from_macos "krb5"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # scons ignores our compiler and flags unless explicitly passed
    args = %W[
      APR=#{Formula["apr"].opt_prefix}
      APU=#{Formula["apr-util"].opt_prefix}
      CC=#{ENV.cc}
      CFLAGS=#{ENV.cflags}
      GSSAPI=#{OS.mac? ? MacOS.sdk_for_formula(self).path/"usr" : Formula["krb5"].opt_prefix}
      LINKFLAGS=#{ENV.ldflags}
      OPENSSL=#{Formula["openssl@3"].opt_prefix}
      PREFIX=#{prefix}
    ]
    args << "ZLIB=#{Formula["zlib-ng-compat"].opt_prefix}" if OS.linux?

    system "scons", *args
    system "scons", "install"
  end

  test do
    # Based on test_ssl_init from https://github.com/apache/serf/blob/trunk/test/test_ssl.c
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <stdlib.h>
      #include <serf.h>

      int main(void) {
        apr_pool_t *pool;
        apr_status_t status;
        serf_bucket_t *decrypt_bkt;
        serf_bucket_t *encrypt_bkt;
        serf_bucket_t *in_stream;
        serf_bucket_t *out_stream;
        serf_bucket_alloc_t *alloc;
        serf_ssl_context_t *ssl_context;

        apr_initialize();
        atexit(apr_terminate);
        apr_pool_create(&pool, NULL);

        alloc = serf_bucket_allocator_create(pool, NULL, NULL);
        in_stream = SERF_BUCKET_SIMPLE_STRING("", alloc);
        out_stream = SERF_BUCKET_SIMPLE_STRING("", alloc);
        decrypt_bkt = serf_bucket_ssl_decrypt_create(in_stream, NULL, alloc);
        ssl_context = serf_bucket_ssl_decrypt_context_get(decrypt_bkt);
        encrypt_bkt = serf_bucket_ssl_encrypt_create(out_stream, ssl_context, alloc);
        status = serf_ssl_use_default_certificates(ssl_context);

        serf_bucket_destroy(decrypt_bkt);
        serf_bucket_destroy(encrypt_bkt);
        apr_pool_destroy(pool);
        assert(status == APR_SUCCESS);
        return 0;
      }
    C

    if OS.mac?
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["apr"].lib/"pkgconfig"
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["apr-util"].lib/"pkgconfig"
    end
    flags = shell_output("pkgconf --cflags --libs serf-1 apr-util-1 apr-1").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
