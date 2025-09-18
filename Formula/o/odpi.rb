class Odpi < Formula
  desc "Oracle Database Programming Interface for Drivers and Applications"
  homepage "https://oracle.github.io/odpi/"
  url "https://github.com/oracle/odpi/archive/refs/tags/v5.6.2.tar.gz"
  sha256 "37c9faaa883df7a3e9e02fb43c33f53e5b6f047361ef51aa1393c34395fd801f"
  license any_of: ["Apache-2.0", "UPL-1.0"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a82a00a3b7f6eddc180909c3c9f601541f4a520e09f4b695b65c4befdcd08010"
    sha256 cellar: :any,                 arm64_sequoia: "b2c296f7ed7f72a6c61c29317ee0dfd6662903a44242232f93b521e6f77ddf8c"
    sha256 cellar: :any,                 arm64_sonoma:  "6835813cdcf8e2123353f61156927548b85a139aca02fe4f6785f3bc23d61562"
    sha256 cellar: :any,                 arm64_ventura: "5f01c67756cb8f42f7088ed45e6d3a37d52198f58e666fae3cce9271cc0285fc"
    sha256 cellar: :any,                 sonoma:        "310372b69f89db3a23aabb5bae53fee57251a8f7acd27462366d93671a890b00"
    sha256 cellar: :any,                 ventura:       "ecf062cd13fdb9b685e7545a1e54469cb216dfbdb8abc7995e1c8eca974efbb7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76c2389fc364dc985c1a5b71d9f9a4af3d2981cee5764381dbf0888a07738c18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be3c0aa33dea75b209fee7fa72ce27be8d58fa2ad1a034d3bb5c2b8a3939182b"
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
