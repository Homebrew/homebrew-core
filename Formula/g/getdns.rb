class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  license "BSD-3-Clause"
  revision 1
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

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "a7c28530f90a7b7154bd2c84bcca93ab7615776eda9903282a5d2ac7889d8e72"
    sha256 cellar: :any,                 arm64_sequoia:  "4de6139ffb48649141f2de34aa4525625427e92f6c663a228457e0d66c0bb4d2"
    sha256 cellar: :any,                 arm64_sonoma:   "f8db532094127a5756d5ee9aa4ac55efe191eda4f5407a95aef2c59ec2e8f32e"
    sha256 cellar: :any,                 arm64_ventura:  "c2f1f059c36f76d0e32acfee307bc6f02a8bb91f850f666704dfe503b79e6035"
    sha256 cellar: :any,                 arm64_monterey: "78497b3d08f57ad15ff67fc0834e7d087b2660fa81863f4f5dd4c7e208de5db8"
    sha256 cellar: :any,                 arm64_big_sur:  "546421d61bf0ed25dddf21496983fd8e93031e4665eeff8fe6badff4fec8c7b4"
    sha256 cellar: :any,                 sonoma:         "7ff99fef869239665dfe345afdccdde0198977b5f50c1705d35c4c40f4b3bfcc"
    sha256 cellar: :any,                 ventura:        "118a3e9288aa2b65bb29d034d97c25813ec762d3edd9ccaed34d38df05e8356b"
    sha256 cellar: :any,                 monterey:       "9a2d1783c4dfe96711732586d68105f9e4d4eca95baefe335bf63f17e04740f9"
    sha256 cellar: :any,                 big_sur:        "1e8c18958a4bcf70bbcaa0a9014c28176fbb02b7ca477033f2315e8535c39b6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "8ce171170b02aee21a4b64f701eafaef27aede8cd2c9b73ded162231e826d29d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd16047c9d5d64db4bc99b8390c6fc80bffe45ca2a1f8c1b7d244d8262babbb0"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libidn2"
  depends_on "libuv"
  depends_on "openssl@3"
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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "-I#{include}", "-o", "test", "test.c", "-L#{lib}", "-lgetdns"
    system "./test"
  end
end
