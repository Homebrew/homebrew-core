class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  license "BSD-3-Clause"
  head "https://github.com/getdnsapi/getdns.git", branch: "develop"

  stable do
    url "https://getdnsapi.net/releases/getdns-1-7-3/getdns-1.7.3.tar.gz"
    sha256 "f1404ca250f02e37a118aa00cf0ec2cbe11896e060c6d369c6761baea7d55a2c"

    # build patch to find libuv, remove in next release
    patch do
      url "https://github.com/getdnsapi/getdns/commit/ee534d10bf1aff0ff62b7ea8c0e2f894e015e429.patch?full_index=1"
      sha256 "7e3afaaaf89fd914eb425de33c3e097ef3df4f467f26434706108ebcda3db10b"
    end
  end

  # We check the GitHub releases instead of https://getdnsapi.net/releases/,
  # since the aforementioned first-party URL has a tendency to lead to an
  # `execution expired` error.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "98dc1fb43eb6c8dd17c0a63994cfc9535a541842b3b6ce8b9d5a68030adc0d28"
    sha256 cellar: :any,                 arm64_monterey: "8554daa08681240029566f03ae8ae692a953c29822e5cc9005d6604cc8c456c7"
    sha256 cellar: :any,                 arm64_big_sur:  "c4ca81b562f87b94686d66626651c43616961472ac43439b841550a6f7deb121"
    sha256 cellar: :any,                 ventura:        "e72a3233240b7668f24f54bf48afc16b208349b9f8b30d9a672495a433b7a21e"
    sha256 cellar: :any,                 monterey:       "7a94535e77a153c1cc310d9f6b9adb10ef76fd22b80be85f26d56b7944eeec53"
    sha256 cellar: :any,                 big_sur:        "abe91d70d22a59db77b4de06d6f70bdb0ae00dcbde58702d2957757d35db30b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34d8afa76df42bce459a0fb6ba57f335c98f0287ca4b33716e3cd6ea66e61b4d"
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
