class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/v4.5.0.tar.gz"
  sha256 "f87042ed1467f158e729f6e763d4467fd4bca4ab7005eefcf6a6b7d6fb210b0b"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "59011081ee7517175e26d371e5912e601606e446beba91ee05f580c7ddaeda4a"
    sha256 cellar: :any,                 arm64_big_sur:  "e59b9d886a6baaae0508bd5f48b595e38f4d198d8e01941b3eb63cd5554034af"
    sha256 cellar: :any,                 monterey:       "0851623d06cab8d9c9460a6ece8bec0d12754191311c80bbbc079af3ed9a07fc"
    sha256 cellar: :any,                 big_sur:        "96db72e780870aae6a876c6f72011efd34098d71120efc19376d9cb8f12bd66f"
    sha256 cellar: :any,                 catalina:       "d069b0002e53fba6d4809a570a7bd0ddaa6dd95d239394282fc26ef3892c4e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "229ec0232e420ee82e36b7652276e465ee469e8f69a52980cd1e504f24a1e888"
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
