class Libevhtp < Formula
  desc "Create extremely-fast and secure embedded HTTP servers with ease"
  homepage "https://github.com/criticalstack/libevhtp"
  url "https://github.com/criticalstack/libevhtp/archive/1.2.18.tar.gz"
  sha256 "316ede0d672be3ae6fe489d4ac1c8c53a1db7d4fe05edaff3c7c853933e02795"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libevent"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
    mkdir_p "./html/docs/"
    system "doxygen", "Doxyfile"
    man3.install Dir["html/docs/man/man3/*.3"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <evhtp.h>
      int main() {
        struct event_base *evbase;
        struct evhtp *htp;
        evbase = event_base_new();
        htp = evhtp_new(evbase, NULL);
        evhtp_free(htp);
        event_base_free(evbase);
        return 0;
      }
    EOS
    system ENV.cc, "test.c",
      "-L#{lib}", "-L#{Formula["libevent"].opt_lib}", "-L#{Formula["openssl"].opt_lib}",
      "-I#{Formula["openssl"].opt_include}",
      "-levent", "-levent_openssl", "-levhtp", "-lssl", "-lcrypto",
      "-o", "test"
    system "./test"
  end
end
