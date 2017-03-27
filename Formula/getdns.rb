class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-0-0/getdns-1.0.0.tar.gz"
  sha256 "a0460269c6536501a7c0af9bc97f9339e05a012f8191d5c10f79042aa62f9e96"
  head "https://github.com/getdnsapi/getdns.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "12ff9ab93eb1fe2727155383a643c5a2d40b2f48e9353e6a385baa5155d89c2f" => :sierra
    sha256 "1ae532218ee2efd6c557a876d062a220ec4d604e24eca19160b394bea813a718" => :el_capitan
    sha256 "4e2eff05d371aedbd66bb428d8f01350134900ed4f4b647897d9c25b8492a45a" => :yosemite
    sha256 "18dcbddc502946fc6a146a52f255a4de75df80235b9b2dfcbaeee054fac355b2" => :mavericks
  end

  devel do
    url "https://getdnsapi.net/releases/getdns-1-1-0-rc1/getdns-1.1.0-rc1.tar.gz"
    sha256 "d91ec104b33880ac901f36b8cc01b22f9086fcf7d4ab94c0cbc56336d1f6bec0"
  end

  depends_on "openssl"
  depends_on "unbound"
  depends_on "libidn"
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
    args << "--with-libevent" if build.with? "libevent"
    args << "--with-libev" if build.with? "libev"
    args << "--with-libuv" if build.with? "libuv"

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
