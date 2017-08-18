class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  revision 2

  stable do
    url "https://getdnsapi.net/releases/getdns-1-1-2/getdns-1.1.2.tar.gz"
    sha256 "685fbd493601c88c90b0bf3021ba0ee863e3297bf92f01b8bf1b3c6637c86ba5"

    # Remove for > 1.1.2
    # Upstream PR from 18 Aug 2017 "Fix issue on OS X 10.10 where TCP fast open
    # is detected but not implemented causing TCP to fail"
    patch do
      url "https://github.com/getdnsapi/getdns/pull/328.patch?full_index=1"
      sha256 "8528bc22d705502f238db7a73e9f1ddbafca398d4b133056b6b4b161adbc3929"
    end
  end

  bottle do
    sha256 "15e207c6fac993a047a179eecff02035046d3a7a29ea17e8fa20e9bc92281eb4" => :sierra
    sha256 "cde110a16c40f5b1d3ce054fffdb7999d5f33b766551e8bcb83f438ddda2d4ce" => :el_capitan
    sha256 "1796fda4fe2bb1d694a0e5c840d097414809bee9bcbc962d82958663d61ab5bf" => :yosemite
  end

  head do
    url "https://github.com/getdnsapi/getdns.git", :branch => "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"
  depends_on "unbound" => :recommended
  depends_on "libidn" => :recommended
  depends_on "libevent" => :recommended
  depends_on "libuv" => :optional
  depends_on "libev" => :optional

  def install
    if build.head?
      system "glibtoolize", "-ci"
      system "autoreconf", "-fi"
    end

    args = [
      "--with-ssl=#{Formula["openssl"].opt_prefix}",
      "--with-trust-anchor=#{etc}/getdns-root.key",
      "--without-stubby",
    ]
    args << "--enable-stub-only" if build.without? "unbound"
    args << "--without-libidn" if build.without? "libidn"
    args << "--with-libevent" if build.with? "libevent"
    args << "--with-libuv" if build.with? "libuv"
    args << "--with-libev" if build.with? "libev"

    # Current Makefile layout prevents simultaneous job execution
    # https://github.com/getdnsapi/getdns/issues/166
    ENV.deparallelize

    system "./configure", "--prefix=#{prefix}", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <getdns/getdns.h>

      int main(int argc, char *argv[]) {
        getdns_context *context;
        getdns_dict *api_info;
        char *pp;
        getdns_return_t r = getdns_context_create(&context, 0);
        if (r != GETDNS_RETURN_GOOD) {
            return -1;
        }
        api_info = getdns_context_get_api_information(context);
        if (!api_info) {
            return -1;
        }
        pp = getdns_pretty_print_dict(api_info);
        if (!pp) {
            return -1;
        }
        puts(pp);
        free(pp);
        getdns_dict_destroy(api_info);
        getdns_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-o", "test", "test.c", "-L#{lib}", "-lgetdns"
    system "./test"
  end
end
