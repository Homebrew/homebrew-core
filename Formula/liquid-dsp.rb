class LiquidDsp < Formula
  desc "Signal processing (DSP) library for software-defined radios"
  homepage "http://liquidsdr.org/"
  url "https://github.com/jgaeddert/liquid-dsp/archive/v1.2.0.tar.gz"
  sha256 "783854b63f5e9a9830dcd95b2c1d5c0bef7d10d22a0e27844a354b59283b6de3"
  head "https://github.com/jgaeddert/liquid-dsp.git"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "fftw" => :recommended

  # Fix configure checks to be able to compile with LLVM/Clang
  patch do
    url "https://github.com/jgaeddert/liquid-dsp/pull/51.patch"
    sha256 "54dc680ba12c7ed89f667e99b84669770c8b56100df47e4b9ba2f793401c4a96"
  end

  def install
    system "./reconf"
    system "./configure", "--prefix=#{prefix}"
    # Note: "make install" in one step does fail
    # This is reported upstream:
    # https://github.com/jgaeddert/liquid-dsp/issues/52
    system "make"
    system "make", "install"
  end

  test do
    # Based on examples/math_primitive_root_example.c
    (testpath/"test.c").write <<-EOS.undent
    #include <liquid/liquid.h>
    int main() {
        if (!liquid_is_prime(3))
            return 1;
        return 0;
    }
    EOS

    flags = %W[
      -I#{include}
      -L#{lib}
      -lliquid
    ]
    system ENV.cc, "-o", "test", "test.c", *flags
    system "./test"
  end
end
