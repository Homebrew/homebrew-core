class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-6-0/getdns-1.6.0.tar.gz"
  sha256 "40e5737471a3902ba8304b0fd63aa7c95802f66ebbc6eae53c487c8e8a380f4a"
  license "BSD-3-Clause"
  head "https://github.com/getdnsapi/getdns.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "e921bc22b5d49af0cf93a3daf035828b286cf28faf4e3916c863214c58cb100d" => :catalina
    sha256 "dddc38b808f9901c02b56755838005ff9f04cb665f40d7145709838e8e38ef99" => :mojave
    sha256 "431361fe29326a2c2b8ecb57b87f8a09c26fc21b5e3170c74bfe61b9ce6b1864" => :high_sierra
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
