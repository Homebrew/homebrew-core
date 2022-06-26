class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.4.1.tar.gz"
  sha256 "c5fc27ef90d12417cb3c2bab32ed539bb4c389fde24ceb6d1df06a0985543c1a"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dda11ae8c672f94e4fdf4aad70ce016f5e2d425c95a6a3ff7b02ce76a43de82d"
    sha256 cellar: :any,                 arm64_big_sur:  "7023283fff8d729f84f84dc60ebc31881bc1f7f6fa478cfc38f27c3e9e23b34a"
    sha256 cellar: :any,                 monterey:       "005821ea6ab7425beb8e9d9514824fc8bc1bcbab7c83cc4a4df1e4b33b77597f"
    sha256 cellar: :any,                 big_sur:        "4c86157d578a1456ceea1c0d1e996cda708facb333defe05d51e775c79662a78"
    sha256 cellar: :any,                 catalina:       "cc754f42c7a0691f91669c1a37f64edb3373cd81695d30fcfa662d261b375be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "436ae47704a747df93bffd53b0f488da55893ef4e33e434ec079fbb002ca4cbb"
  end

  def install
    system "make"

    lib.install Dir["lib/*"]
    include.install Dir["include/*"]
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
