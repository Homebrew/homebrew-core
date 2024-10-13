class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v5.3.0.tar.gz"
  sha256 "6081c6492dc48dee558e0125e33e39fae32d4c9357941fccb6b49c6c232fb828"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "cfa9baa5ff834db4e5ace6be5a40351ba7f3ed5592626cb63ae0110edb475d36"
    sha256 cellar: :any,                 arm64_sonoma:   "f6f1abb468f3b3232cbeb86d7da47d80928e41689e1760ae580ad644b021ef09"
    sha256 cellar: :any,                 arm64_ventura:  "7b44b00447d2c7a0b96088f4a2626f7246e4e3cb3d1545b04e1ef6609e6b6946"
    sha256 cellar: :any,                 arm64_monterey: "d48085f8629d9e36c6a3ea80f327cdfa30e6998f926486b2b326a4463a83b96d"
    sha256 cellar: :any,                 sonoma:         "95f24904d50d8a6661613009099ebc6450fe292144fcf50e38bcedfd76cc7a60"
    sha256 cellar: :any,                 ventura:        "9e104eb738d2b202ae6a9513246a8078440501a0d63f7bd5542d16f6f55def4f"
    sha256 cellar: :any,                 monterey:       "122b0123d42827384a83fc67c5ae0de5defa3d35f2438050764cffd350e86e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66a5771894b201742ab1a0c9469eaa8bfadcf1137eff5046370fa830fa827957"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end
