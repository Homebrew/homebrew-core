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
    sha256 cellar: :any,                 arm64_big_sur: "98a47841711b19d9dffd76486574d639b8721342356dffa55cf98f6b4777a7cf"
    sha256 cellar: :any,                 big_sur:       "f59ad5922a0249bd68bdf0241446d1762210899fbbdf9d927c03410e0d8a4e15"
    sha256 cellar: :any,                 catalina:      "6598dce2c0208622854555338ac788bdc78ec74b9368861008e2a110ef01581c"
    sha256 cellar: :any,                 mojave:        "0abd0fddbea51c1e89c1588e95a5f384e1c9fcde09385075d1f3999ae387d29e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "059a87084efb2922630ae77970844cfd61cc11324627b1de8674d26723e72e08"
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
