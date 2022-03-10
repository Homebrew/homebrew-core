class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  url "https://getdnsapi.net/releases/getdns-1-7-0/getdns-1.7.0.tar.gz"
  sha256 "ea8713ce5e077ac76b1418ceb6afd25e6d4e39e9600f6f5e81d3a3a13a60f652"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/getdnsapi/getdns.git", branch: "develop"

  # We check the GitHub releases instead of https://getdnsapi.net/releases/,
  # since the aforementioned first-party URL has a tendency to lead to an
  # `execution expired` error.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "10850358ef91882e727c103bfabbd4fa6c096ddbb02f6708f1cc91fc46ae16d2"
    sha256 cellar: :any,                 arm64_big_sur:  "6418fbe20eac5674ac1492eccba8941c57ab6111fca7a174144a0f7732c037c1"
    sha256 cellar: :any,                 monterey:       "9a8a08d251a2a8284b4535d6afef601b8a91162b0005eff783d62b726579160f"
    sha256 cellar: :any,                 big_sur:        "d98dc03e72b3e2e6814f47c8d947ff7667d65b79cf4b11f3b1913d2e17f51e84"
    sha256 cellar: :any,                 catalina:       "3481bfeb92cb2b50ad019c3cc816fe73c3f26dec20e80b4b52536e83c8ff9752"
    sha256 cellar: :any,                 mojave:         "fabcba2c64119aa84e892266a93260d6c8a6d650e754568b6f5767c9223de001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f445d5e97136b0171dac28b641e30d24461300978697259ae9272313695765c"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libidn2"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "unbound"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPATH_TRUST_ANCHOR_FILE=#{etc}/getdns-root.key",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
