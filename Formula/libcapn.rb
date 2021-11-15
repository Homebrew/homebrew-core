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
    sha256 arm64_monterey: "fdbe12af86921a05628ff8d522ca3723879295fbc252f24c446b04eaa478c06b"
    sha256 arm64_big_sur:  "b87f88777484a94bcbd142d107b9b29317962ab9ff318857c90c01ade15c6f45"
    sha256 monterey:       "bbd7f98414ee35c8d19582ab17d2a79fe70d892cf5e1bbcc2f1e51789392b616"
    sha256 big_sur:        "e355824f9490a5bb90964a7b5bf4b69735ebe72560bf112e2f083111ca31550e"
    sha256 catalina:       "67b634beae31705b6664702473cb42a686c50d84f4d0ec530bbe4e360c292dba"
    sha256 mojave:         "3b4b1f331e7e79c6a99826c5ffd385df3f199a7d72c897e9fd31150be26303cb"
    sha256 high_sierra:    "a3cd6c452f96c9914f41fe22c1c0b5518c282569dffcebe7d6f38783ce2fb4d1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  # Compatibility with OpenSSL 1.1
  # Original: https://github.com/adobkin/libcapn/pull/46.diff?full_index=1
  patch do
    url "https://github.com/adobkin/libcapn/commit/d5e7cd219b7a82156de74d04bc3668a07ec96629.patch?full_index=1"
    sha256 "d027dc78f490c749eb04c36001d28ce6296c2716325f48db291ce8e62d56ff26"
  end
  patch do
    url "https://github.com/adobkin/libcapn/commit/5fde3a8faa6ce0da0bfe67834bec684a9c6fc992.patch?full_index=1"
    sha256 "caa70babdc4e028d398e844df461f97b0dc192d5c6cc5569f88319b4fcac5ff7"
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
