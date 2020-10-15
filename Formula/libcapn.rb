class Libcapn < Formula
  desc "C library to send push notifications to Apple devices"
  homepage "https://web.archive.org/web/20181220090839/libcapn.org/"
  license "MIT"
  revision 1
  head "https://github.com/adobkin/libcapn.git"

  stable do
    url "https://github.com/adobkin/libcapn/archive/v2.0.0.tar.gz"
    sha256 "6a0d786a431864178f19300aa5e1208c6c0cbd2d54fadcd27f032b4f3dd3539e"

    resource "jansson" do
      url "https://github.com/akheron/jansson.git",
        revision: "8f067962f6442bda65f0a8909f589f2616a42c5a"
    end
  end

  bottle do
    sha256 "67b634beae31705b6664702473cb42a686c50d84f4d0ec530bbe4e360c292dba" => :catalina
    sha256 "3b4b1f331e7e79c6a99826c5ffd385df3f199a7d72c897e9fd31150be26303cb" => :mojave
    sha256 "a3cd6c452f96c9914f41fe22c1c0b5518c282569dffcebe7d6f38783ce2fb4d1" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # Compatibility with OpenSSL 1.1
  # Original: https://github.com/adobkin/libcapn/pull/46.diff?full_index=1
  patch do
    url "https://github.com/adobkin/libcapn/commit/d5e7cd219b7a82156de74d04bc3668a07ec96629.diff?full_index=1"
    sha256 "18db4435c4417cbb3052714808f50f32827effbd7f03f9ae37ab7659af53050f"
  end
  patch do
    url "https://github.com/adobkin/libcapn/commit/5fde3a8faa6ce0da0bfe67834bec684a9c6fc992.diff?full_index=1"
    sha256 "d0c87b4ffb514fa1f8a1930a73e53b76e6512b39d69fc02ed74456307c3521ae"
  end

  def install
    # head gets jansson as a git submodule
    (buildpath/"src/third_party/jansson").install resource("jansson") if build.stable?
    system "cmake", ".", "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                         *std_cmake_args
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/send_push_message.c",
                   "-o", "send_push_message",
                   "-I#{Formula["openssl@1.1"].opt_include}",
                   "-L#{lib}/capn", "-lcapn"
    output = shell_output("./send_push_message", 255)
    assert_match "unable to use specified PKCS12 file (errno: 9012)", output
  end
end
