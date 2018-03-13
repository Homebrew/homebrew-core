class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-4-1/getdns-1.4.1.tar.gz"
  sha256 "245233dc780f615b6ab1472f2b9cdcd957a451a736f3036717d0da466ab1c51e"

  bottle do
    sha256 "d80644beb47575554da2473d294956859e8ff96b45f38d0f23a4b49c64d7a1ff" => :high_sierra
    sha256 "9483906284202975572bdf52a8556de1bf25be69ad36edd703528692a487c342" => :sierra
    sha256 "5dfc428706294f5f608749170520feb4d6b87bdeb362800e8fea50314a4a2a2c" => :el_capitan
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
