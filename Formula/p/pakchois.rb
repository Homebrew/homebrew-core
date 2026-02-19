class Pakchois < Formula
  desc "PKCS #11 wrapper library"
  homepage "https://www.manyfish.co.uk/pakchois/"
  url "https://www.manyfish.co.uk/pakchois/pakchois-0.4.tar.gz"
  sha256 "d73dc5f235fe98e4d1e8c904f40df1cf8af93204769b97dbb7ef7a4b5b958b9a"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?pakchois[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256                               arm64_tahoe:    "7f225dfdf9d1ac84b9bbd38a83157664f5b03b6951a09b9888b8b67ab586ae59"
    sha256                               arm64_sequoia:  "9634938ed93d02adaa5e477a29ee2f128d058f63cfbbe9c460ead07b53ac23d1"
    sha256                               arm64_sonoma:   "c5e557c4172e6800ca80178acedc0a6029c4870ceb37ed56d6a3944f32a271ee"
    sha256                               arm64_ventura:  "d8467830fd424d6fea0a0f0ff82949262d55d4221fa2a2d630b0679d374c803f"
    sha256                               arm64_monterey: "fb701bf9c363b4e09f285fa9c6f60aba921a93f826c37afd5fcc54b0bc5e4ed1"
    sha256 cellar: :any,                 arm64_big_sur:  "86e77a851ff2c0de31cf5e4f2587711b7b1bcc742fb878df1ce69fde836fd864"
    sha256                               sonoma:         "95aae319e6a66c11f7f6826ded41ac0b2b45e4768319267321866118d828289c"
    sha256                               ventura:        "b6a9c3707dd02ec65d927974bd8534be159b2dd977f14df74907eadb0165e953"
    sha256                               monterey:       "f53bdb6cb2f47b0ed2e1df5f2c80f9568c3b2c55463de2cfdfe742da945364c0"
    sha256 cellar: :any,                 big_sur:        "fd91b09bb010ac37483a910b0431c6082903ee843a15f4cc767bde57ce0b7267"
    sha256 cellar: :any,                 catalina:       "ca82f2950582bc54e46122eb71ff8e8acdc739772baf53ab2d545755f03303f8"
    sha256                               arm64_linux:    "f1d80aa63347835060c9d57d93c36226dc116d3c4b573e3db74128a86e4bfc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9e96d8cef014042091db67065c8b02439cba4cfd381ca7651bc721ec120ad4a"
  end

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <pakchois/pakchois.h>
      #include <stdio.h>

      int main(void) {
        pakchois_module_t *mod = NULL;

        // load non-existent module
        ck_rv_t rv = pakchois_module_load(&mod, "nonexistent-module");
        printf("pakchois_module_load returned: %lu\\n", rv);

        if (rv != 0) {
          printf("Module load failed as expected\\n");
        }

        if (mod != NULL) {
          pakchois_module_destroy(mod);
        }

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpakchois", "-o", "test"
    assert_match "Module load failed as expected", shell_output("./test")
  end
end
