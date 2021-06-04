class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-7-0/getdns-1.7.0.tar.gz"
  sha256 "ea8713ce5e077ac76b1418ceb6afd25e6d4e39e9600f6f5e81d3a3a13a60f652"
  license "BSD-3-Clause"
  head "https://github.com/getdnsapi/getdns.git", branch: "develop"

  # We check the GitHub releases instead of https://getdnsapi.net/releases/,
  # since the aforementioned first-party URL has a tendency to lead to an
  # `execution expired` error.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e2c42a1a184ac62037b940d3dda3de8204212db716f712556cba00099697b557"
    sha256 cellar: :any, big_sur:       "51668c45104b39417c144eb17583f7fb23b8fde01789a6bc1ce74afe45b158b2"
    sha256 cellar: :any, catalina:      "e921bc22b5d49af0cf93a3daf035828b286cf28faf4e3916c863214c58cb100d"
    sha256 cellar: :any, mojave:        "dddc38b808f9901c02b56755838005ff9f04cb665f40d7145709838e8e38ef99"
    sha256 cellar: :any, high_sierra:   "431361fe29326a2c2b8ecb57b87f8a09c26fc21b5e3170c74bfe61b9ce6b1864"
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
