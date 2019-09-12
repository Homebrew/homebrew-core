class Libcapn < Formula
  desc "C library to send push notifications to Apple devices"
  homepage "https://web.archive.org/web/20181220090839/libcapn.org/"
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
    rebuild 1
    sha256 "eaf58b0b396a97f84f8b477bc0f668577640c25b0dbbdbba08361bf584546c79" => :mojave
    sha256 "795b187aa64a56ca4ae63a398b8422200b839eed12ab6d5676d277fd3e6226ba" => :high_sierra
    sha256 "c23c4a366edf36912ebc70fadde0207bc780ef32742459015230d4adbf71028a" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl" # no OpenSSL 1.1 support

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
