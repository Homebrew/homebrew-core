class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v26.1.0.tar.gz"
  sha256 "22e245171ecbc0684f385905985f9c70a09d02c9079d316a654a229f7abdb179"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    manifest_sha256 "04ff151fd6565fbb70291fdfa0050710c600a0e41d721fc2f53475b56aa14126"
    sha256 cellar: :any, arm64_golden_gate: "61264544cce450113adc03b177925c9d65ec2ebd554b594e919d127caa907fd7"
    sha256 cellar: :any, arm64_tahoe:       "751a0f4be7e7fdf57d5e620099a65b244e52a6ab679167c5b64130ff434c1036"
    sha256 cellar: :any, arm64_sequoia:     "ab5dd584de889e3d22cdd83a5ad487d509e5de52d017204e785268b1ce20722f"
    sha256 cellar: :any, arm64_linux:       "629161db5cd9e8343720b7d58a8d1b17e6545f69f9642322fc554d83bdbfa2be"
    sha256 cellar: :any, x86_64_linux:      "d6eba96c090b83fd6732c29837007270a200cdf8c1fdfe4880bd67f073496711"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <dpi.h>

      int main()
      {
        dpiContext* context = NULL;
        dpiErrorInfo errorInfo;

        dpiContext_create(DPI_MAJOR_VERSION, DPI_MINOR_VERSION, &context, &errorInfo);

        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lodpic", "-o", "test"
    system "./test"
  end
end
