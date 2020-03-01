class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-6-0/getdns-1.6.0.tar.gz"
  sha256 "40e5737471a3902ba8304b0fd63aa7c95802f66ebbc6eae53c487c8e8a380f4a"
  head "https://github.com/getdnsapi/getdns.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "e9d55e0441197296fb86a1b1799d7a3774648b65578ea78231da2a50ad5161b8" => :catalina
    sha256 "c7cde9c6422419585abaf6b30b14d1213ee728d6298527689714f61e1003dfcd" => :mojave
    sha256 "b105523ee31c31dd16484babf53659e82a2950f095f5949d811733b481f1d84b" => :high_sierra
    sha256 "aab96082494eadf2d8806211a3597fdd3356938181e39b8c77a6146a8767ce97" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libidn2"
  depends_on "openssl@1.1"
  depends_on "unbound"

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DBUILD_TESTING=OFF",
                         "-DPATH_TRUST_ANCHOR_FILE=#{etc}/getdns-root.key"
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
