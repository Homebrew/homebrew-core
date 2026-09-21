class Libmowgli < Formula
  desc "Core framework for Atheme applications"
  homepage "https://github.com/atheme/libmowgli-2"
  url "https://github.com/atheme/libmowgli-2/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "b7faab2fb9f46366a52b51443054a2ed4ecdd04774c65754bf807c5e9bdda477"
  license "ISC"
  revision 1
  head "https://github.com/atheme/libmowgli-2.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_golden_gate: "9f0a38e5b357eb81d5c8e17c8f6e00a2974b874764fe3b1fc74297c73ee43f21"
    sha256 cellar: :any, arm64_tahoe:       "e474d2310973130f4e8a7a027f7e0bbb6d09a6f302a8333fbf6f72957658976d"
    sha256 cellar: :any, arm64_sequoia:     "e9b11ec4c11869ec8d32a9bff60576e35bc8b3046f24222f150efc3bf21b65a2"
    sha256 cellar: :any, arm64_sonoma:      "4783618f3b79ef69afb32934018b69da53dd39c29ac7f23b158bb5fa827adc1c"
    sha256 cellar: :any, arm64_linux:       "1104dcc85ec062f874eeb26db299f6e41cf03f8fb61311c72c993ca43c8e1084"
    sha256 cellar: :any, x86_64_linux:      "4239622c39f18f4866995a42fcba92052c60592e256a87a8f958948b1dd64be4"
  end

  depends_on "openssl@4"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{formula_opt_prefix("openssl@4")}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <mowgli.h>

      int main(int argc, char *argv[]) {
        char buf[65535];
        mowgli_random_t *r = mowgli_random_create();
        mowgli_formatter_format(buf, 65535, "%1! %2 %3 %4.",\
                    "sdpb", "Hello World", mowgli_random_int(r),\
                    0xDEADBEEF, TRUE);
        puts(buf);
        mowgli_object_unref(r);
        return EXIT_SUCCESS;
      }
    C
    system ENV.cc, "-I#{include}/libmowgli-2", "-o", "test", "test.c", "-L#{lib}", "-lmowgli-2"
    system "./test"
  end
end
