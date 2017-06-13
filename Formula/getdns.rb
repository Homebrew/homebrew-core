class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-1-0/getdns-1.1.0.tar.gz"
  sha256 "aa47bca275b97f623dc6799cee97d3465fa46521d94bd9892e08e8d5d88f09c3"
  head "https://github.com/getdnsapi/getdns.git", :branch => "develop"

  bottle do
    sha256 "91fccbcb1ea628fefa2848fccc318953dfc71d34ffeff44adbf596352ceac16b" => :sierra
    sha256 "8181df1a84e1c4affdc521ab9062f4834b9279e22d3c2bc312192857063961c8" => :el_capitan
    sha256 "f9259f55b25aa8c20a880c90c63fbbbc2a33da2b68a617799d43d0ae7abcacb1" => :yosemite
  end

  devel do
    url "https://getdnsapi.net/releases/getdns-1-1-1rc1/getdns-1.1.1rc1.tar.gz"
    sha256 "f63340b1d05410b875217c6abd7066586fc55a811db4ae90ffd01d2240e05e57"
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
