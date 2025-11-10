class Chttp < Formula
  desc "Open-source C library for HTTP requests"
  homepage "https://github.com/json031/chttp"
  url "https://github.com/json031/chttp/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "6fd22b6cfad7078180b3fd76f4a2c1970672015786701c90595d91037320e1ba"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "cjson"
  depends_on "curl"

  def install
    ENV.append "CFLAGS", "-I#{Formula["cjson"].opt_include}"
    ENV.append "LDFLAGS", "-L#{Formula["cjson"].opt_lib}"

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Simply compile a test program
    (testpath/"test.c").write <<~EOS
      #include <chttp.h>
      int main() { return 0; }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lchttp", "-o", "test"
    system "./test"
  end
end
