class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-5-2/getdns-1.5.2.tar.gz"
  sha256 "1826a6a221ea9e9301f2c1f5d25f6f5588e841f08b967645bf50c53b970694c0"
  revision 1

  bottle do
    cellar :any
    sha256 "c293ffbb7cf95d03a0aaefe3192528e1ac48a45b178dbe7221c36cba3eef3193" => :mojave
    sha256 "a1e16166536523e0a38364c3a3734c3283ecfd45836f30bf2f3f134f75987306" => :high_sierra
    sha256 "014023b37aaa7099c05c21667733b9272285251f099c393c21f5e609fa0be7f0" => :sierra
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
