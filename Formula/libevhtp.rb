class Libevhtp < Formula
  desc "Create extremely-fast and secure embedded HTTP servers with ease"
  homepage "https://criticalstack.com/"
  url "https://github.com/criticalstack/libevhtp/archive/1.2.18.tar.gz"
  sha256 "316ede0d672be3ae6fe489d4ac1c8c53a1db7d4fe05edaff3c7c853933e02795"
  revision 2

  bottle do
    cellar :any
    sha256 "1c9eac0e309c108015f1cd45de5e1de60a962dbe7d8ad702ceec92ca09b1a733" => :mojave
    sha256 "f78dc220333d1a20a11243c11cc8e212e75487b6a01fabe02c2d2a18d779b9c2" => :high_sierra
    sha256 "a27afd7497a33479dc608320cb8ad7641c83c9c85b736037aa228e1c98c0a71d" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

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
                   "-I#{Formula["openssl@1.1"].opt_include}",
                   "-I#{Formula["libevent"].opt_include}",
                   "-L#{Formula["openssl@1.1"].opt_lib}",
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
