class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-1-0/getdns-1.1.0.tar.gz"
  sha256 "aa47bca275b97f623dc6799cee97d3465fa46521d94bd9892e08e8d5d88f09c3"

  bottle do
    sha256 "eb0a9afe598e9611814d9ca21ff7e897dd4b2182df29797f2624a22ed661a892" => :sierra
    sha256 "db7b5abcbb815b325cf60a334b31eee7f65485bf037895d61b24fb368200ea13" => :el_capitan
    sha256 "0c372cc5b79342c227df9ab8dc678a064f2ffd351409d8aa5536d6522d7012aa" => :yosemite
  end

  head do
    url "https://github.com/getdnsapi/getdns.git", :branch => "develop"
    depends_on "libtool" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl"
  depends_on "unbound" => :recommended
  depends_on "libevent" => :recommended
  depends_on "libuv" => :optional
  depends_on "libev" => :optional

  def install
    if build.head?
      system "glibtoolize", "-ci"
      system "autoreconf", "-fi"
    end

    args = %W[
      --prefix=#{prefix}
      --with-ssl=#{Formula["openssl"].opt_prefix}
      --with-trust-anchor=#{etc}/getdns-root.key
    ]
    # stringprep support was seemingly dropped in libidn2.
    args << "--without-libidn"

    args << "--enable-stub-only" if build.without? "unbound"
    args << "--with-libevent" if build.with? "libevent"
    args << "--with-libuv" if build.with? "libuv"
    args << "--with-libev" if build.with? "libev"

    # Current Makefile layout prevents simultaneous job execution
    # https://github.com/getdnsapi/getdns/issues/166
    ENV.deparallelize

    system "./configure", *args
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
