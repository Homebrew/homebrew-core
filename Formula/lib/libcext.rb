class Libcext < Formula
  desc "C utility library for Common Pipeline Library (CPL)"
  homepage "https://www.eso.org/sci/software/cpl/"
  url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cext/cext-1.3.2.tar.gz"
  sha256 "622532430a63ad26756eb51751c1815c96bca4722ca30cb961ebb35a2072201d"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://ftp.eso.org/pub/dfs/pipelines/libraries/cext/"
    regex(/href=.*?cext[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "29e252f3c56b2d68da1aa5da66f4551bebd87e53d6db8449fc25059c022dddf7"
    sha256 cellar: :any, arm64_sequoia: "f18f3718af6c5b721c033f913bb2c5692ce09c92e33479c728a59f825c902dec"
    sha256 cellar: :any, arm64_sonoma:  "13fab2ed8c3c4c5589ec52a94ad4eae20de0c10d7365e1804f04f3790284e9ce"
    sha256 cellar: :any, sonoma:        "9791a79885d754c78fd120a01072164ccb1d7f82d14b1a45c93449e497ace04e"
    sha256 cellar: :any, arm64_linux:   "27dab44f698fa0473bd0a1333023942141fcadeb2b21e5b2dc4a2cadae4c0884"
    sha256 cellar: :any, x86_64_linux:  "97189a77ae9c48a742fc50a75e3607b7a3b95f1e8c9bed299ef17a399f29c707"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <cxstring.h>

      int main(void) {
        cx_string *s = cx_string_create("hello");
        printf("%s %d\\n", cx_string_get(s), (int)cx_string_size(s));
        cx_string_delete(s);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcext", "-o", "test"
    assert_equal "hello 5", shell_output("./test").strip
  end
end
