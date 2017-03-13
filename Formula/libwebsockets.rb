class Libwebsockets < Formula
  desc "C websockets server library"
  homepage "https://libwebsockets.org"
  url "https://github.com/warmcat/libwebsockets/archive/v2.2.0.tar.gz"
  sha256 "1be5d9b959eab118efb336ef07d6c1e0af08a17409f06167a55ae874221f11a1"
  head "https://github.com/warmcat/libwebsockets.git"

  bottle do
    sha256 "ee61a613972a636e61dc68df72e78d66b33f656a9996c9965ed3e03edac01334" => :sierra
    sha256 "bdf869501cfcbff68c705f9007ea9c47308e4f544798b68fe55c65ec1c5f566a" => :el_capitan
    sha256 "55fea7bd9bbdc3de96119541fc5057fe74386b0c6bec17271ce6b4c8c40601ef" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <openssl/ssl.h>
      #include <libwebsockets.h>

      int main()
      {
        struct lws_context_creation_info info;
        memset(&info, 0, sizeof(info));
        struct lws_context *context;
        context = lws_create_context(&info);
        lws_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["openssl"].opt_prefix}/include", "-lwebsockets", "-o", "test"
    system "./test"
  end
end
