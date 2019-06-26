class Libevhtp < Formula
  desc "Create extremely-fast and secure embedded HTTP servers with ease"
  homepage "https://criticalstack.com/"
  url "https://github.com/criticalstack/libevhtp/archive/1.2.18.tar.gz"
  sha256 "316ede0d672be3ae6fe489d4ac1c8c53a1db7d4fe05edaff3c7c853933e02795"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libevent"
  depends_on "openssl"

  def install
    system "cmake", "-DEVHTP_BUILD_SHARED=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    ".", *std_cmake_args
    system "make", "install"
    mkdir_p "./html/docs/"
    system "doxygen", "Doxyfile"
    man3.install Dir["html/docs/man/man3/*.3"]
    doc.install Dir["html/docs/html/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <evhtp.h>

      int main() {
        struct event_base *base;
        struct evhtp *htp;
        base = event_base_new();
        htp = evhtp_new(base, NULL);
        evhtp_free(htp);
        event_base_free(base);
        return 0;
      }
    EOS

    system ENV.cc, "test.c",
                   "-I#{include}",
                   "-I#{Formula["openssl"].opt_include}",
                   "-I#{Formula["libevent"].opt_include}",
                   "-L#{Formula["openssl"].opt_lib}",
                   "-L#{Formula["libevent"].opt_lib}",
                   "-L#{lib}",
                   "-levhtp",
                   "-levent",
                   "-levent_openssl",
                   "-lssl",
                   "-lcrypto",
                   "-o", "test"
    system "./test"
  end
end
