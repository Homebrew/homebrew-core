class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-5-1/getdns-1.5.1.tar.gz"
  sha256 "5686e61100599c309ce03535f9899a5a3d94a82cc08d10718e2cd73ad3dc28af"

  bottle do
    sha256 "a85a2629ebc943460859ac6751e3ca76f476ab0b2f4710ebaa303146e00724b2" => :mojave
    sha256 "1669b3d80b3c4f5560b61e7bcf73d211980060f0ab895cd626ea7f6f06d8537b" => :high_sierra
    sha256 "fa2b076bbc0ff746e699f7f734d0a909f468dc939b497ceaf5450d554749665a" => :sierra
  end

  head do
    url "https://github.com/getdnsapi/getdns.git", :branch => "develop"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libevent"
  depends_on "libidn"
  depends_on "openssl"
  depends_on "unbound"

  def install
    if build.head?
      system "glibtoolize", "-ci"
      system "autoreconf", "-fi"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--with-libevent",
                          "--with-ssl=#{Formula["openssl"].opt_prefix}",
                          "--with-trust-anchor=#{etc}/getdns-root.key",
                          "--without-stubby"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <getdns/getdns.h>
      #include <stdio.h>

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
