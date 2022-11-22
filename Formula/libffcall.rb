class Libffcall < Formula
  desc "GNU Foreign Function Interface library"
  homepage "https://www.gnu.org/software/libffcall/"
  url "https://ftp.gnu.org/gnu/libffcall/libffcall-2.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/libffcall/libffcall-2.4.tar.gz"
  sha256 "8ef69921dbdc06bc5bb90513622637a7b83a71f31f5ba377be9d8fd8f57912c2"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb0b3113b4075bd871c9dbc7c1c0af213e77b700aaedc4cf5532b1944015defc"
    sha256 cellar: :any,                 arm64_monterey: "58dd56d1ab429bde2b8078bb3737682b57a37a7d67b70e8c27bcc023f988e2fd"
    sha256 cellar: :any,                 arm64_big_sur:  "d7ace5f73fe02c38febe33718fbb293e765f7d1909763b39dc280d410e2a1488"
    sha256 cellar: :any,                 ventura:        "ee2b7df162625a59cd9ac90a61a91a238138cf244a385c1c94dc50d90319d546"
    sha256 cellar: :any,                 monterey:       "947d7c231e88bbf9a4037e15c75abb158334b895efb9ea15e698e340e0d95f6b"
    sha256 cellar: :any,                 big_sur:        "61cb42231c842a5559808582e374420e058fe76cc60b47f08b383c2751536caa"
    sha256 cellar: :any,                 catalina:       "1412d8bb030690981a6322f18a3ef686aaa3f7b1ab3e390be2767e83cb5160a5"
    sha256 cellar: :any,                 mojave:         "093534e26c77187ebd27234802635357c458cfe6956edc618d6292e707bc5fdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b9ade24ffa94a150150dd446d25f7fdee0497c98d334cbf9d4b3cc0ed649990"
  end

  def install
    ENV.deparallelize
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"callback.c").write <<~EOS
      #include <stdio.h>
      #include <callback.h>

      typedef char (*char_func_t) ();

      void function (void *data, va_alist alist)
      {
        va_start_char(alist);
        va_return_char(alist, *(char *)data);
      }

      int main() {
        char *data = "abc";
        callback_t callback = alloc_callback(&function, data);
        printf("%s\\n%c\\n",
          is_callback(callback) ? "true" : "false",
          ((char_func_t)callback)());
        free_callback(callback);
        return 0;
      }
    EOS
    flags = ["-L#{lib}", "-lffcall", "-I#{lib}/libffcall-#{version}/include"]
    system ENV.cc, "-o", "callback", "callback.c", *(flags + ENV.cflags.to_s.split)
    output = shell_output("#{testpath}/callback")
    assert_equal "true\na\n", output
  end
end
