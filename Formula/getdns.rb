class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-2-1/getdns-1.2.1.tar.gz"
  sha256 "3ed37135b4aa447160fa68205b8552477b6829da48eb63943994c6193e1d891d"

  bottle do
    sha256 "095aa79a5d4dd416502c843dd3ab004814cc17017f3c3199ce03f6cbad19d9b8" => :high_sierra
    sha256 "ec8b8937dbe8b2e2c52c2d4bde4484294e93fefccc451214ef79205b46277929" => :sierra
    sha256 "70291f3a9b33a0531ff3043036ee6fcbe54aa6ea648e1a2156e219954c60174e" => :el_capitan
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

    system "./configure", "--prefix=#{prefix}", *args
    system "make"
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
