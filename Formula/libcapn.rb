class Libcapn < Formula
  desc "C library to send push notifications to Apple devices"
  homepage "http://libcapn.org/"
  head "https://github.com/adobkin/libcapn.git"

  stable do
    url "https://github.com/adobkin/libcapn/archive/v2.0.0.tar.gz"
    sha256 "6a0d786a431864178f19300aa5e1208c6c0cbd2d54fadcd27f032b4f3dd3539e"

    resource "jansson" do
      url "https://github.com/akheron/jansson.git",
        :revision => "8f067962f6442bda65f0a8909f589f2616a42c5a"
    end
  end

  bottle do
    cellar :any
    sha256 "228057a01ee8f67b8cb4122798d12e19b596c7cb1c5c7bc216ade96a0a632ef4" => :el_capitan
    sha256 "35071a03d946979792e7ac7792e2bf6e94073c242ccf58066fefd0d49c7d72d4" => :yosemite
    sha256 "70d7e47ff2ad168c6f26e61d86805b4e0d1c37015c1e3528d589195a66e9d185" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    # head gets jansson as a git submodule
    if build.stable?
      (buildpath/"src/third_party/jansson").install resource("jansson")
    end
    system "cmake", ".", "-DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}",
                         *std_cmake_args
    system "make", "install"
    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/send_push_message.c",
                   "-o", "send_push_message",
                   "-I#{Formula["openssl"].opt_include}",
                   "-L#{lib}/capn", "-lcapn"
    output = shell_output("./send_push_message", 255)
    assert_match "unable to use specified PKCS12 file (errno: 9012)", output
  end
end
