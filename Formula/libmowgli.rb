class Libmowgli < Formula
  desc "Core framework for Atheme applications"
  homepage "https://github.com/atheme/libmowgli-2"
  url "https://github.com/atheme/libmowgli-2/archive/v2.1.3.tar.gz"
  sha256 "b7faab2fb9f46366a52b51443054a2ed4ecdd04774c65754bf807c5e9bdda477"
  license "ISC"
  revision 1
  head "https://github.com/atheme/libmowgli-2.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1485e9c5e8e5869333781f7125f4c583ea94a2697190a0873af3ec51d3131731"
    sha256 cellar: :any,                 arm64_big_sur:  "fe4733bd50b52c347b5f4f4af0e0126454227646a0851a15b01bd4dc90637f50"
    sha256 cellar: :any,                 monterey:       "08a877b66f5ae61da1d1f02a2d8eb570a56fe62e4bcda1482d5a4f951f76318a"
    sha256 cellar: :any,                 big_sur:        "71b4314960c13147708edb90db5ea48f339dcdecd2e5bb0273f831066913ad84"
    sha256 cellar: :any,                 catalina:       "02bbaff929fa3e3967ec4184ce36fcf71ece1dca9aeedad67ca3c9533495fa52"
    sha256 cellar: :any,                 mojave:         "68656add47085df19786c9d419d7dd2e880514f3a5fa63838362ef92807c3420"
    sha256 cellar: :any,                 high_sierra:    "061c1fc5a942024894205ee47a5ffc41fae5dde42ca6b744f66dad5d4a2e60fe"
    sha256 cellar: :any,                 sierra:         "a83b21ccd87a25d26122ab813afbd24ef6bc07e6c92b16db11813d4fab71a055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7646bd88a24aa8d426ec1cbbf4b32504f0f0c062f257c71b445349667f6bf34"
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
    EOS
    system ENV.cc, "-I#{include}/libmowgli-2", "-o", "test", "test.c", "-L#{lib}", "-lmowgli-2"
    system "./test"
  end
end
