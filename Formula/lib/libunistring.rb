class Libunistring < Formula
  desc "C string library for manipulating Unicode strings"
  homepage "https://www.gnu.org/software/libunistring/"
  url "https://ftp.gnu.org/gnu/libunistring/libunistring-1.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/libunistring/libunistring-1.3.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libunistring/libunistring-1.3.tar.gz"
  sha256 "8ea8ccf86c09dd801c8cac19878e804e54f707cf69884371130d20bde68386b7"
  license any_of: ["GPL-2.0-only", "LGPL-3.0-or-later"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3cd26bae2d5fcf61294f14c18e5e7ec773a59ed1bf710fb92055e0db0244e909"
    sha256 cellar: :any,                 arm64_sonoma:  "38e44e319bfe11ec892bc6451d86b687d990ea01b4810b5d8ad1f794d531d82f"
    sha256 cellar: :any,                 arm64_ventura: "b0d7a7078508070bd67589f5060a92100bd1c4aea2a41bf19e7ee8442f483df6"
    sha256 cellar: :any,                 sonoma:        "e919f6ee2fe8a40addea1e1840eab8855e66812e18dfe05c130618ce517e2880"
    sha256 cellar: :any,                 ventura:       "9aebb86a6fb622dd2699db2b1b65c82d1b5aaa35f81d0ae4335c57e9411c36e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2bd48b651db50b0ad0205b27b38a21303b6a49b567dd5b682cc1b9562e9ea0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25ff65379463fe4a51008a36c45a963ebc8d13d054ce606e3fbb6635ea634311"
  end

  def install
    # macOS iconv implementation is slightly broken since Sonoma.
    # This is also why we skip `make check`.
    # https://github.com/coreutils/gnulib/commit/bab130878fe57086921fa7024d328341758ed453
    # https://savannah.gnu.org/bugs/?65686
    ENV["am_cv_func_iconv_works"] = "yes" if OS.mac? && MacOS.version == :sequoia
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "check" if !OS.mac? || MacOS.version < :sonoma || MacOS.version > :sequoia
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <uniname.h>
      #include <unistdio.h>
      #include <unistr.h>
      #include <stdlib.h>
      int main (void) {
        uint32_t s[2] = {};
        uint8_t buff[12] = {};
        if (u32_uctomb (s, unicode_name_character ("BEER MUG"), sizeof s) != 1) abort();
        if (u8_sprintf (buff, "%llU", s) != 4) abort();
        printf ("%s\\n", buff);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lunistring",
                   "-o", "test"
    assert_equal "🍺", shell_output("./test").chomp
  end
end
