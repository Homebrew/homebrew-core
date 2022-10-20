class Libevhtp < Formula
  desc "Create extremely-fast and secure embedded HTTP servers with ease"
  homepage "https://github.com/Yellow-Camper/libevhtp/"
  url "https://github.com/Yellow-Camper/libevhtp/archive/1.2.18.tar.gz"
  sha256 "316ede0d672be3ae6fe489d4ac1c8c53a1db7d4fe05edaff3c7c853933e02795"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "74d01b65e01f09e30dbde389981531716691c8c10c0f0694f5cc4edf365d948a"
    sha256 cellar: :any,                 arm64_big_sur:  "12b7dadd090f1b53ac313baf685f7bb73640aa6dc8bb34566cddf8ebdaf438f6"
    sha256 cellar: :any,                 monterey:       "a7d9b1b3082bb70e39606571a35592c47de05a2f63e693a52cf6334e2f2bcea7"
    sha256 cellar: :any,                 big_sur:        "388f9d507acbec7351f20395547744657ad1e83c2a82e83ecee8160da9ba6332"
    sha256 cellar: :any,                 catalina:       "507466763ef1710ef11b82d02a5229d1445ba6393a553d75926b8fe5d727d871"
    sha256 cellar: :any,                 mojave:         "bfd6cffbcad95d0db38d4b699af24dd3aab1a82b0bdfc7ea7136b212cecab37c"
    sha256 cellar: :any,                 high_sierra:    "72be53d01a0ab668255e9ab605c4d7b6c16e4ca1a3f68b026c3c9ae1fe77af50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944924e814dc284b4f34bd754190c976c55b9ec6cf8e614ae0950b45655ff86b"
  end

  deprecate! date: "2021-07-13", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "cmake", "-DEVHTP_BUILD_SHARED=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DEVHTP_DISABLE_REGEX=ON",
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
