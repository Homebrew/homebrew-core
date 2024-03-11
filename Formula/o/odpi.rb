class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v5.2.0.tar.gz"
  sha256 "9e2eb3a10e4ab89691d847d5106cfcde8c1126b7959d3ee06076ea3f5b5a9d19"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0ae837553420860a05ee8a968d94707e6fa63f3cfe4af2f5aaa6ce78684ae5d6"
    sha256 cellar: :any,                 arm64_ventura:  "42e505193fe3ee620ed59799d46e2f266a97bb5b42b88bf6bc92893d3feba889"
    sha256 cellar: :any,                 arm64_monterey: "1667775ddb5b95274926618af85ff668670491949c9d02d985e33e327a2b3416"
    sha256 cellar: :any,                 sonoma:         "808c639d7dd0dfa186b263cc86e060ad899874de5b4e9e4d107664c4eac376e1"
    sha256 cellar: :any,                 ventura:        "03f46387c66a736c46c0d3c12ef8e4401964e74ecff25f00f075b58703326610"
    sha256 cellar: :any,                 monterey:       "e904271b52791db57833e68b4143dd0a0ad42a305449ebb9a838be1e73c6d9c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7af4e66755b2e2d131ee8b5c26c3e02b8832e990f1184c00137ed5affb415309"
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
