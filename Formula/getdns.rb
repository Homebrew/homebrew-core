class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-0-0/getdns-1.0.0.tar.gz"
  sha256 "a0460269c6536501a7c0af9bc97f9339e05a012f8191d5c10f79042aa62f9e96"
  head "https://github.com/getdnsapi/getdns.git", :branch => "develop"

  bottle do
    sha256 "eb0a9afe598e9611814d9ca21ff7e897dd4b2182df29797f2624a22ed661a892" => :sierra
    sha256 "db7b5abcbb815b325cf60a334b31eee7f65485bf037895d61b24fb368200ea13" => :el_capitan
    sha256 "0c372cc5b79342c227df9ab8dc678a064f2ffd351409d8aa5536d6522d7012aa" => :yosemite
  end

  devel do
    url "https://getdnsapi.net/releases/getdns-1-1-0-rc1/getdns-1.1.0-rc1.tar.gz"
    sha256 "d91ec104b33880ac901f36b8cc01b22f9086fcf7d4ab94c0cbc56336d1f6bec0"
  end

  depends_on "openssl"
  depends_on "unbound" => :recommended
  depends_on "libidn" => :recommended
  depends_on "libevent" => :recommended
  depends_on "libuv" => :optional
  depends_on "libev" => :optional

  if build.head?
    depends_on "libtool"
    depends_on "autoconf"
    depends_on "automake"
  end

  def install
    if build.head?
      system "glibtoolize", "-ci"
      system "autoreconf", "-fi"
    end

    args = [
      "--with-ssl=#{Formula["openssl"].opt_prefix}",
      "--with-trust-anchor=#{etc}/getdns-root.key",
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
